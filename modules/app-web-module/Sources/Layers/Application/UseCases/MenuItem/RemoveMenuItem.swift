//
//  RemoveMenuItem.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDomain
import WebDomain

public struct RemoveMenuItem: UseCase {
    struct Action: PermissionAction {
        let key = WebPermissions.MenuItems.delete
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMenuItem>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteMenuItem>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String
        public let menuId: String

        public init(
            id: String,
            menuId: String
        ) {
            self.id = id
            self.menuId = menuId
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
            guard let model = try await scope.menuItem.find(id: input.id),
                model.menuId == input.menuId
            else {
                return false
            }
            return try await scope.menuItem.delete(id: model.id)
        }
    }
}
