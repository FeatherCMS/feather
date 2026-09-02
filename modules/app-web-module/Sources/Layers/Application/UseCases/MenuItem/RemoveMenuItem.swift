import FeatherApplication
import FeatherContracts
import FeatherDomain
import WebContracts
import WebDomain

//
//  RemoveMenuItem.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

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
        public let ids: [String]
        public let menuId: String

        public init(
            ids: [String],
            menuId: String
        ) {
            self.ids = ids
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
            try await scope.menuItem.delete(ids: input.ids)
        }
    }
}
