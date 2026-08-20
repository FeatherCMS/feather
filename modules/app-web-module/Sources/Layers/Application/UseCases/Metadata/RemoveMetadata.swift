import WebContracts
//
//  RemoveMetadata.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDomain
import WebDomain

public struct RemoveMetadata: UseCase {
    struct Action: PermissionAction {
        let key = WebPermissions.Metadata.delete
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMetadata>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteMetadata>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String

        public init(
            id: String
        ) {
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

        let id = input.id

        return try await transaction.run { scope in
            try await scope.metadata.delete(id: id)
        }
    }
}
