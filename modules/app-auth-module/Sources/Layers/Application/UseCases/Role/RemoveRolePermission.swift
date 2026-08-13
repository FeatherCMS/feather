//
//  RemoveRolePermission.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
import FeatherApplication
import FeatherContracts

public struct RemoveRolePermission: UseCase {
    struct Action: PermissionAction {
        let key = AuthPermissions.AccessControl.delete
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteRolePermissions>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteRolePermissions>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let roleId: String
        public let permissionId: String

        public init(
            roleId: String,
            permissionId: String
        ) {
            self.roleId = roleId
            self.permissionId = permissionId
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
            try await scope.rolePermissions.delete(
                roleId: input.roleId,
                permissionId: input.permissionId
            )
        }
    }
}
