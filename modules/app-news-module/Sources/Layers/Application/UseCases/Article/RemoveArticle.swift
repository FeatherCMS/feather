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
    ) async throws -> [String] {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await transaction.run { scope in
            var deletedIds = [String]()
            for id in input.ids {
                _ = try await scope.metadata.delete(
                    reference: .existing(.init(type: "news.article", id: id))
                )
            }
            deletedIds = try await scope.article.delete(ids: input.ids)
            return deletedIds
        }
    }
}
