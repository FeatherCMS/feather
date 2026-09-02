import AccountContracts
import AccountDomain
import FeatherApplication
import FeatherContracts
import UserDomain

//
//  RemoveInvitation.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct RemoveInvitation: UseCase {
    struct Action: PermissionAction {
        let key = AccountPermissions.Invitations.delete
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
        public let ids: [String]

        public init(ids: [String]) {
            self.ids = ids
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> [String] {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await transaction.run { scope in
            try await scope.invitation.delete(ids: input.ids)
        }
    }
}
