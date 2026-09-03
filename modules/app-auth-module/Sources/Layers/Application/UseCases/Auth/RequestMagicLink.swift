//
//  RequestMagicLink.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain
import Foundation
import SystemApplication
import UserDomain

public struct RequestMagicLink: UseCase {
    let transaction: any TransactionExecutor<WriteRequestMagicLink>
    let mailSender: any MailSender

    public init(
        transaction: any TransactionExecutor<WriteRequestMagicLink>,
        mailSender: any MailSender
    ) {
        self.transaction = transaction
        self.mailSender = mailSender
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
        let result: (token: String, publicBaseURL: String, template: String?)? =
            try await transaction.run { scope in
                guard
                    let authEmail = try await scope.authEmail.findBy(
                        email: input.email
                    )
                else {
                    return nil
                }

                let token = generateToken()

                _ = try await scope.magicLink.insert(
                    MagicLink.create(
                        authEmailId: authEmail.id,
                        token: token,
                        isPersistent: input.isPersistent
                    )
                )

                guard
                    let publicBaseURL = try await scope.variable.get(
                        "web-settings-public-base-url"
                    ),
                    !publicBaseURL.isEmpty
                else {
                    throw UseCaseError(
                        reason: .validation,
                        logMessage: "public_site_url_not_configured",
                        userFriendlyMessage:
                            "The public site URL is not configured."
                    )
                }

                return (
                    token: token,
                    publicBaseURL: publicBaseURL,
                    template: try await scope.variable.get(
                        "auth.magic_link.email.template"
                    )
                )
            }

        guard let result else {
            return false
        }

        let template =
            result.template
                ?? #"""
                Hello,

                This is your sign-in link:

                {{url}}

                Cheers,
                Application Team.
                """#
        let body =
            template
            .replacingOccurrences(
                of: "{{url}}",
                with:
                    "\(result.publicBaseURL)/magic-link/verify/?token=\(result.token)"
            )
            .replacingOccurrences(of: "{{token}}", with: result.token)
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
