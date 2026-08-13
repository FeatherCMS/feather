//
//  GetPublicCategory.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDomain
import Foundation
import NewsDomain
import WebApplication

public struct GetPublicCategory {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }

    let query: any QueryExecutor<ReadPublicNewsCategory>

    public init(
        query: any QueryExecutor<ReadPublicNewsCategory>
    ) {
        self.query = query
    }

    public func execute(
        id: String
    ) async throws -> PublicNewsCategoryDetail {
        let now = Date()
        return try await query.run { scope in
            guard
                let metadata = try await scope.metadata.find(
                    referenceType: "news.category",
                    referenceID: id
                ),
                metadata.isDirectlyAccessible(at: now)
            else {
                throw Error(message: "Category not found")
            }

            let category = try await scope.category.find(id: id)
            let articles = try await Self.publicArticles(
                matchingCategoryID: id,
                now: now,
                context: scope
            )
            return .init(
                id: category.id,
                title: category.title,
                excerpt: category.excerpt,
                content: category.content,
                imageAssetId: category.imageAssetId,
                imageURL: "",
                media: nil,
                metadata: metadata,
                articles: articles
            )
        }
    }
}

extension GetPublicCategory {
    fileprivate static func publicArticles(
        matchingCategoryID categoryID: String,
        now: Date,
        context: ReadPublicNewsCategory
    ) async throws -> [PublicNewsArticleSummary] {
        let articles = try await context.article.list(
            query: .init(
                page: .init(size: 10000, number: 1),
                sort: [.init(field: .createdAt, direction: .desc)]
            )
        )
        var result: [PublicNewsArticleSummary] = []
        for item in articles.items {
            let article = try await context.article.find(id: item.id)
            guard article.categoryIds.contains(categoryID) else {
                continue
            }
            guard
                let metadata = try await context.metadata.find(
                    referenceType: "news.article",
                    referenceID: item.id
                ),
                metadata.isPublic(at: now)
            else {
                continue
            }
            result.append(
                .init(
                    id: item.id,
                    title: item.title,
                    excerpt: item.excerpt,
                    imageAssetId: article.imageAssetId,
                    imageURL: "",
                    media: nil,
                    metadata: metadata
                )
            )
        }
        return result
    }
}
