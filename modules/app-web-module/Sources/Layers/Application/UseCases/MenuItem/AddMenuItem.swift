import WebContracts
//
//  AddMenuItem.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDomain
import WebDomain

public struct AddMenuItem: UseCase {

    struct Action: PermissionAction {
        let key = WebPermissions.MenuItems.create
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
        public let menuId: String
        public let label: String
        public let url: String
        public let priority: Int
        public let isBlank: Bool
        public let permission: String
        public let authentication: MenuItemAuthentication
        public let notes: String

        public init(
            menuId: String,
            label: String,
            url: String,
            priority: Int,
            isBlank: Bool,
            permission: String,
            authentication: MenuItemAuthentication = .any,
            notes: String
        ) {
            self.menuId = menuId
            self.label = label
            self.url = url
            self.priority = priority
            self.isBlank = isBlank
            self.permission = permission
            self.authentication = authentication
            self.notes = notes
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> MenuItemDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let model = try await transaction.run { scope in
            try await scope.menuItem.insert(
                MenuItem.create(
                    menuId: input.menuId,
                    label: input.label,
                    url: input.url,
                    priority: input.priority,
                    isBlank: input.isBlank,
                    permission: input.permission,
                    authentication: input.authentication,
                    notes: input.notes
                )
            )
        }
        return model.asDetail
    }
}
