import FeatherApplication
import FeatherContracts
import FeatherDomain
import WebContracts
import WebDomain

//
//  EditMenuItem.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct EditMenuItem: UseCase {

    struct Action: PermissionAction {
        let key = WebPermissions.MenuItems.update
    }

    struct Error: UseCaseError {
        let message: String
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
        public let label: String?
        public let url: String?
        public let priority: Int?
        public let isBlank: Bool?
        public let permission: String?
        public let authentication: MenuItemAuthentication?
        public let notes: String?

        public init(
            id: String,
            menuId: String,
            label: String?,
            url: String?,
            priority: Int?,
            isBlank: Bool?,
            permission: String?,
            authentication: MenuItemAuthentication? = nil,
            notes: String?
        ) {
            self.id = id
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
            guard var model = try await scope.menuItem.find(id: input.id)
            else {
                throw Error(message: "Menu item not found")
            }
            guard model.menuId == input.menuId else {
                throw Error(message: "Menu item not found")
            }

            try model.update(
                label: input.label,
                url: input.url,
                priority: input.priority,
                isBlank: input.isBlank,
                permission: input.permission,
                authentication: input.authentication,
                notes: input.notes
            )

            return try await scope.menuItem.update(model)
        }
        return model.asDetail
    }
}
