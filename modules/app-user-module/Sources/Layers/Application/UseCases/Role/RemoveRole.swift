import FeatherApplication
import FeatherContracts
import UserContracts
import UserDomain

//
//  RemoveRole.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct RemoveRole: UseCase {
    struct Action: PermissionAction {
        let key = UserPermissions.Roles.delete
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteRole>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteRole>
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
    ) async throws -> Bool {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await transaction.run { scope in
            try await scope.role.delete(ids: input.ids)
        }
    }
}
