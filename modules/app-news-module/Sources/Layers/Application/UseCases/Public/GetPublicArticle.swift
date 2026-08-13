//
//  GetPublicArticle.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDomain
import Foundation
import NewsDomain
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
            var categories: [PublicNewsCategorySummary] = []
            for categoryID in article.categoryIds {
                guard
                    let categoryMetadata = try await scope.metadata.find(
                        referenceType: "news.category",
                        referenceID: categoryID
                    ),
                    categoryMetadata.isPublic(at: now)
                else {
                    continue
                }
                let category = try await scope.category.find(id: categoryID)
                categories.append(
                    .init(
                        id: category.id,
                        title: category.title,
                        excerpt: category.excerpt,
                        imageAssetId: category.imageAssetId,
                        imageURL: "",
                        media: nil,
                        metadata: categoryMetadata
                    )
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
