//
//  RemoveCategory.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDomain
import NewsDomain
import WebDomain

public struct RemoveCategory: UseCase {
    struct Action: PermissionAction {
        let key = NewsPermissions.Categories.delete
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteCategoryArticlesMetadata>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteCategoryArticlesMetadata>
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
            try await scope.article.removeCategory(id: id)
            let removedCategory = try await scope.category.delete(id: id)
            _ = try await scope.metadata.delete(
                reference: .existing(.init(type: "news.category", id: id))
            )
            return removedCategory
        }
    }
}
