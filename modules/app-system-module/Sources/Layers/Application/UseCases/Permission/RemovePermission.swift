import FeatherApplication
import FeatherContracts
import FeatherDomain
import SystemContracts
import SystemDomain

//
//  RemovePermission.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct RemovePermission: UseCase {
    struct Action: PermissionAction {
        let key = SystemPermissions.Permissions.delete
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WritePermission>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WritePermission>
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

    public typealias Output = [String]

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> Output {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await transaction.run { scope in
            try await scope.permission.delete(ids: input.ids)
        }
    }
}
