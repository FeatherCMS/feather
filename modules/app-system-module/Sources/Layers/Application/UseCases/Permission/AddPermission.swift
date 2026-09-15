import FeatherApplication
import FeatherContracts
import FeatherDomain
import SystemContracts
import SystemDomain

//
//  AddPermission.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

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
        public let key: String
        public let name: String?
        public let notes: String?

        public init(
            key: String,
            name: String?,
            notes: String?
        ) {
            self.key = key
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
                        key: input.key,
                        name: name,
                        notes: notes
                    )
                )
            }
            .asDetail
    }
}
