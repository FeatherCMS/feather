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

import struct Foundation.Date

public struct RequestMagicLink: UseCase {
    let transaction: any TransactionExecutor<WriteAuth>
    let mailSender: any MailSender

    public init(
        transaction: any TransactionExecutor<WriteAuth>,
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

        try await mailSender.send(
            .init(
                from: .init("info@binarybirds.com", name: "Binary Birds"),
                to: [.init(input.email)],
                subject: "Application - Sign In Link",
                body: #"""
                    Hello,

                    This is your sign-in token:

                    \#(token)

                    Use this token in the app on the magic link verification screen.

                    Cheers,
                    Application Team.
                    """#
            )
        )
        return true
    }
}
