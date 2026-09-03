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
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
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
        try await transaction.run { scope, context in
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
            guard
                !(try await scope.invitation.delete(ids: [invitation.id]))
                    .isEmpty
            else {
                throw Error(message: "Invitation already used")
            }
            return .init(
                id: updated.id,
                name: updated.name,
                roleIds: invitation.roleIDs,
                status: .init(rawValue: updated.status.rawValue) ?? .invited,
                createdAt: updated.createdAt,
                updatedAt: updated.updatedAt
            )
        }
    }
}
