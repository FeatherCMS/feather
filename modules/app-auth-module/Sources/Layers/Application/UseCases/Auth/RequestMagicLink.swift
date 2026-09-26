//
//  RequestMagicLink.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
public import FeatherApplication
public import FeatherContracts
import Foundation
import SystemApplication

public struct RequestMagicLink: UseCase {
    public enum Error: UseCaseError {
        case mailFromNotConfigured

        public var message: String {
            switch self {
            case .mailFromNotConfigured:
                "System mail from address is not configured. Configure the system-settings-mail-from-address variable in System → Variables."
            }
        }
    }

    private struct MailContext: Sendable {
        let token: String
        let publicBaseURL: String
        let template: String?
        let mailFromAddress: String
    }

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
        let result: MailContext? =
            try await transaction.run { scope in
                guard
                    let mailFromAddress = try await scope.variable.get(
                        "system-settings-mail-from-address"
                    )?.whitespaceTrimmed,
                    !mailFromAddress.isEmpty
                else {
                    throw Error.mailFromNotConfigured
                }

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

                let configuredPublicBaseURL =
                    try await scope.variable.get(
                        "web-settings-public-base-url"
                    )?
                    .whitespaceTrimmed
                let publicBaseURL =
                    configuredPublicBaseURL.flatMap {
                        $0.isEmpty ? nil : $0
                    }
                    ?? "http://localhost:3456"

                return MailContext(
                    token: token,
                    publicBaseURL: publicBaseURL,
                    template: try await scope.variable.get(
                        "auth.magic_link.email.template"
                    ),
                    mailFromAddress: mailFromAddress
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
                from: .init(result.mailFromAddress, name: "Binary Birds"),
                to: [.init(input.email)],
                subject: "Application - Sign In Link",
                body: body
            )
        )
        return true
    }
}
