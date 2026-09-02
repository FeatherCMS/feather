import FeatherApplication
import FeatherContracts
import FeatherDomain
import NewsContracts
import NewsDomain
import WebDomain

//
//  RemoveArticle.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

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
        public let ids: [String]

        public init(ids: [String]) { self.ids = ids }
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
            var removed = true
            for id in input.ids {
                removed = try await scope.article.delete(ids: [id]) && removed
                _ = try await scope.metadata.delete(
                    reference: .existing(.init(type: "news.article", id: id))
                )
            }
            return removed
        }
    }
}
