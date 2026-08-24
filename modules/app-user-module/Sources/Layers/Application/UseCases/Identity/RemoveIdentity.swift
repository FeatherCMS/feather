import FeatherApplication
import FeatherContracts
import UserContracts
import UserDomain

//
//  RemoveIdentity.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct RemoveIdentity: UseCase {
    struct Action: PermissionAction {
        let key = UserPermissions.Identities.delete
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteIdentity>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteIdentity>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
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
            try await scope.identity.delete(id: input.id)
        }
    }
}
