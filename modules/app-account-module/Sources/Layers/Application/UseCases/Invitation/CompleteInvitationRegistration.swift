//
//  CompleteInvitationRegistration.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 07. 16.

import AccountDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain
import UserApplication
import UserDomain

public struct CompleteInvitationRegistration: UseCase {
    struct Error: UseCaseError {
        let message: String
    }

    let transaction: any ContextualTransactionExecutor<WriteInvitation>
    public init(
        transaction: any ContextualTransactionExecutor<WriteInvitation>
    ) {
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let token: String
        public let password: String

        public init(token: String, password: String) {
            self.token = token
            self.password = password
        }
    }

    public func execute(
        input: Input
    ) async throws -> IdentityDetail {
        return try await transaction.run { scope, context in
            guard
                var invitation = try await scope.invitation.findBy(
                    token: input.token
                ),
                var identity = try await scope.identity.findBy(
                    id: invitation.userId
                ),
                identity.status == .invited
            else {
                throw Error(message: "Invitation or identity not found")
            }
            try await scope.credential.create(
                userID: identity.id,
                email: invitation.email,
                password: input.password,
                context: context
            )
            try await scope.identity.replaceRoleIds(
                identityId: identity.id,
                roleIds: invitation.roleIDs
            )
            try invitation.consume()
            identity.update(status: .active)
            let updated = try await scope.identity.update(identity)
            guard try await scope.invitation.delete(id: invitation.id) else {
                throw Error(message: "Invitation already used")
            }
            return updated.asDetail
        }
    }
}
