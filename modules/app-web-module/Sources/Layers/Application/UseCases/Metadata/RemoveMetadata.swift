import FeatherApplication
import FeatherContracts
import FeatherDomain
import WebContracts
import WebDomain

//
//  RemoveMetadata.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

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
        public let ids: [String]

        public init(ids: [String]) {
            self.ids = ids
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> [String] {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await transaction.run { scope in
            try await scope.metadata.delete(ids: input.ids)
        }
    }
}
