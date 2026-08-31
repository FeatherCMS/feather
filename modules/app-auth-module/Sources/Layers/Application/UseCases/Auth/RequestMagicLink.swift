//
//  RequestMagicLink.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain
import UserDomain
import SystemApplication
import Foundation

public struct RequestMagicLink: UseCase {
    let transaction: any TransactionExecutor<WriteAuth>
    let mailSender: any MailSender
    let variable: any VariableQueries

    public init(
        transaction: any TransactionExecutor<WriteAuth>,
        mailSender: any MailSender,
        variable: any VariableQueries
    ) {
        self.transaction = transaction
        self.mailSender = mailSender
        self.variable = variable
    }

    public struct Input: DTO {
        public let email: String
        public let isPersistent: Bool

        public init(
            email: String,
            isPersistent: Bool
        ) {
            self.email = email
            self.isPersistent = isPersistent
        }
    }

    public func execute(
        _ input: Input
    ) async throws -> Bool {
        let token: String? = try await transaction.run { scope in
            guard
                let credential = try await scope.credential.findBy(
                    email: input.email
                )
            else {
                return nil
            }

            let token = generateToken()

            _ = try await scope.magicLink.insert(
                MagicLink.create(
                    credentialId: credential.id,
                    token: token,
                    isPersistent: input.isPersistent
                )
            )

            return token
        }

        guard let token else {
            return false
        }

        guard let publicBaseURL = try await variable.get("web-settings-public-base-url"),
              !publicBaseURL.isEmpty
        else {
            throw UseCaseError(
                reason: .validation,
                logMessage: "public_site_url_not_configured",
                userFriendlyMessage: "The public site URL is not configured."
            )
        }

        let template = try await variable.get("auth.magic_link.email.template")
            ?? #"""
                Hello,

                This is your sign-in link:

                {{url}}

                Cheers,
                Application Team.
                """#
        let body = template
            .replacingOccurrences(of: "{{url}}", with: "\(publicBaseURL)/magic-link/verify/?token=\(token)")
            .replacingOccurrences(of: "{{token}}", with: token)
            .replacingOccurrences(of: "{{email}}", with: input.email)

        try await mailSender.send(
            .init(
                from: .init("info@binarybirds.com", name: "Binary Birds"),
                to: [.init(input.email)],
                subject: "Application - Sign In Link",
                body: body
            )
        )
        return true
    }
}
