//
//  RemoveArticle.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDomain
import NewsDomain
import WebDomain

public struct RemoveArticle: UseCase {
    struct Action: PermissionAction {
        let key = NewsPermissions.Articles.delete
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteArticleMetadata>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteArticleMetadata>
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
            let removedArticle = try await scope.article.delete(id: id)
            _ = try await scope.metadata.delete(
                reference: .existing(.init(type: "news.article", id: id))
            )
            return removedArticle
        }
    }
}
