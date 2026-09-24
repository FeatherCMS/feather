//
//  ListPublicArticles.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
public import FeatherContracts
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
        let result = try await executePage(
            pageSize: limit ?? 10000
        )
        return result.items
    }

    public func executePage(
        search: String? = nil,
        pageNumber: Int = 1,
        pageSize: Int = 12
    ) async throws -> PublicNewsArticlePage {
        let now = Date()
        return try await query.run { scope in
            let normalizedSearch: String?
            if let search {
                let trimmedSearch = search.trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
                normalizedSearch = trimmedSearch.isEmpty
                    ? nil
                    : trimmedSearch
            } else {
                normalizedSearch = nil
            }
            let baseQuery = ArticleList.Query(
                search: normalizedSearch
            )
            let total = try await scope.article.countPublic(
                query: baseQuery,
                categoryID: nil
            )
            let resolvedPageSize = max(1, pageSize)
            let pageCount = max(
                1,
                (total + resolvedPageSize - 1) / resolvedPageSize
            )
            let currentPage = min(max(1, pageNumber), pageCount)
            let articles = try await scope.article.listPublic(
                query: .init(
                    page: .init(
                        size: resolvedPageSize,
                        number: currentPage
                    ),
                    sort: [.init(field: .createdAt, direction: .desc)],
                    search: normalizedSearch
                ),
                categoryID: nil
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
            }
            let categoryIDsByArticleID = try await scope.article.categoryIDs(
                for: result.map(\.id)
            )
            return .init(
                items: result.map { item in
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
                },
                total: total,
                page: currentPage,
                pageSize: resolvedPageSize
            )
        }
    }
}
