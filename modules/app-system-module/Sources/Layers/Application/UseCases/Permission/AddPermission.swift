import SystemContracts
//
//  AddPermission.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDomain
import SystemDomain

public struct AddPermission: UseCase {
    struct Action: PermissionAction {
        let key = SystemPermissions.Permissions.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WritePermission>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WritePermission>,
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String
        public let name: String?
        public let notes: String?

        public init(
            id: String,
            name: String?,
            notes: String?
        ) {
            self.id = id
            self.name = name
            self.notes = notes
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> PermissionDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let name = input.name
        let notes = input.notes

        return
            try await transaction.run { scope in
                try await scope.permission.insert(
                    Permission.create(
                        id: input.id,
                        name: name,
                        notes: notes
                    )
                )
            }
            .asDetail
    }
}
