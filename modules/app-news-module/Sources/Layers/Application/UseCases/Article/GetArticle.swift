import NewsContracts
//
//  GetArticle.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDomain
import NewsDomain
import WebApplication

public struct GetArticle: UseCase {
    struct Action: PermissionAction {
        let key = NewsPermissions.Articles.read
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadArticleMetadata>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadArticleMetadata>
    ) {
        self.authorizer = authorizer
        self.query = query
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
    ) async throws -> ArticleDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let id = input.id

        return try await query.run { scope in
            let article = try await scope.article.find(id: id)
            guard
                let metadata = try await scope.metadata.find(
                    referenceType: "news.article",
                    referenceID: id
                )
            else {
                throw Error(message: "Article metadata not found")
            }
            return .init(
                id: article.id,
                title: article.title,
                excerpt: article.excerpt,
                content: article.content,
                imageAssetId: article.imageAssetId,
                categoryIds: article.categoryIds,
                metadata: metadata,
                createdAt: article.createdAt,
                updatedAt: article.updatedAt
            )
        }
    }
}
