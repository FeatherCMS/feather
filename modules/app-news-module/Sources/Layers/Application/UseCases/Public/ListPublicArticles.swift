//
//  ListPublicArticles.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import Foundation
import WebApplication

public struct ListPublicArticles {
    let query: any QueryExecutor<ReadPublicNewsArticle>

    public init(
        query: any QueryExecutor<ReadPublicNewsArticle>
    ) {
        self.query = query
    }

    public func execute(
        limit: Int? = nil
    ) async throws -> [PublicNewsArticleSummary] {
        let now = Date()
        return try await query.run { scope in
            let articles = try await scope.article.list(
                query: .init(
                    page: .init(size: limit ?? 10000, number: 1),
                    sort: [.init(field: .createdAt, direction: .desc)]
                )
            )
            var result: [PublicNewsArticleSummary] = []
            for item in articles.items {
                guard
                    let metadata = try await scope.metadata.find(
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
                        imageAssetId: item.imageAssetId,
                        imageURL: "",
                        media: nil,
                        metadata: metadata,
                        readingTime: NewsReadingTime.minutes(for: item.content),
                        categoryIDs: []
                    )
                )
                if let limit, result.count == limit {
                    break
                }
            }
            var categoryIDsByArticleID: [String: [String]] = [:]
            if limit == nil {
                categoryIDsByArticleID = try await scope.article.categoryIDs(
                    for: result.map(\.id)
                )
            }
            return result.map { item in
                .init(
                    id: item.id,
                    title: item.title,
                    excerpt: item.excerpt,
                    imageAssetId: item.imageAssetId,
                    imageURL: item.imageURL,
                    media: item.media,
                    metadata: item.metadata,
                    readingTime: item.readingTime,
                    categoryIDs: categoryIDsByArticleID[item.id] ?? []
                )
            }
        }
    }
}
