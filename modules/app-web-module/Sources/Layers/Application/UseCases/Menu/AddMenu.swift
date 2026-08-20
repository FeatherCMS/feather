import WebContracts
//
//  AddMenu.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDomain
import WebDomain

public struct AddMenu: UseCase {

    struct Action: PermissionAction {
        let key = WebPermissions.Menus.create
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMenu>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteMenu>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let key: String
        public let name: String
        public let notes: String

        public init(
            key: String,
            name: String,
            notes: String
        ) {
            self.key = key
            self.name = name
            self.notes = notes
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> MenuDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let model = try await transaction.run { scope in
            if try await scope.menu.find(key: input.key) != nil {
                throw Error(message: "Menu key already exists")
            }
            return try await scope.menu.insert(
                Menu.create(
                    key: input.key,
                    name: input.name,
                    notes: input.notes
                )
            )
        }
        return model.asDetail
    }
}
