import AccountContracts
//
//  EditInvitation.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AccountDomain
import FeatherApplication
import FeatherContracts
import UserDomain

public struct EditInvitation: UseCase {
    struct Action: PermissionAction {
        let key = AccountPermissions.Invitations.update
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteInvitationOnly>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteInvitationOnly>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String
        public let email: String?

        public init(
            id: String,
            email: String?
        ) {
            self.id = id
            self.email = email
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> InvitationDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let model = try await transaction.run { scope in
            guard var model = try await scope.invitation.findBy(id: input.id)
            else {
                throw Error(message: "Invitation not found")
            }

            try model.update(email: input.email)
            return try await scope.invitation.update(model)
        }

        return model.asDetail
    }
}
