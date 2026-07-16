//
//  CompleteInvitationRegistration.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 07. 16.

import Application
import Domain
import UserDomain

public struct CompleteInvitationRegistration: UseCase {
    struct Error: UseCaseError {
        let message: String
    }

    let transaction: any TransactionExecutor<WriteInvitation>
    let passwordHasher: any PasswordHasher

    public init(
        transaction: any TransactionExecutor<WriteInvitation>,
        passwordHasher: any PasswordHasher
    ) {
        self.transaction = transaction
        self.passwordHasher = passwordHasher
    }

    public struct Input: DTO {
        public let token: String
        public let password: String

        // TODO: Add profile and account-settings input once the account-settings
        // persistence and API contract are available.

        public init(token: String, password: String) {
            self.token = token
            self.password = password
        }
    }

    public func execute(
        input: Input
    ) async throws -> AccountDetail {
        let hash = try await hashPassword(
            using: passwordHasher,
            original: input.password
        )
        return try await transaction.run { context in
            guard
                var invitation = try await context.invitation.findBy(
                    token: input.token
                ),
                let accountRepository = context.account,
                var account = try await accountRepository.findBy(
                    id: invitation.accountID
                ),
                account.status == .invited
            else {
                throw Error(message: "Invitation or account not found")
            }
            try invitation.consume()
            try account.update(
                password: input.password,
                passwordHash: hash,
                status: .active
            )
            let updated = try await accountRepository.update(account)
            guard try await context.invitation.delete(id: invitation.id) else {
                throw Error(message: "Invitation already used")
            }
            return updated.asDetail
        }
    }
}
