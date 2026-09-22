//
//  GetPublicArticle.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import Foundation
import WebApplication

public struct GetPublicArticle {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }

    let query: any QueryExecutor<ReadPublicNewsArticle>

    public init(
        query: any QueryExecutor<ReadPublicNewsArticle>
    ) {
        self.query = query
    }

    public func execute(
        id: String
    ) async throws -> PublicNewsArticleDetail {
        let now = Date()
        return try await query.run { scope in
            guard
                let metadata = try await scope.metadata.find(
                    referenceType: "news.article",
                    referenceID: id
                ),
                metadata.isDirectlyAccessible(at: now)
            else {
                throw Error(message: "Article not found")
            }

            let article = try await scope.article.find(id: id)
            let categories = try await scope.category
                .find(ids: article.categoryIds)
                .filter { $0.metadata.isPublic(at: now) }
                .map {
                    PublicNewsCategorySummary(
                        id: $0.id,
                        title: $0.title,
                        excerpt: $0.excerpt,
                        imageAssetId: $0.imageAssetId,
                        imageURL: "",
                        media: nil,
                        metadata: $0.metadata
                    )
                }

            return .init(
                id: article.id,
                title: article.title,
                excerpt: article.excerpt,
                content: article.content,
                imageAssetId: article.imageAssetId,
                imageURL: "",
                media: nil,
                metadata: metadata,
                categories: categories
            )
        }
    }
}
