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

    public func execute(ids: [String]) async throws
        -> [PublicNewsArticleSummary]
    {
        var seenIDs = Set<String>()
        let ids = ids.filter { seenIDs.insert($0).inserted }
        guard !ids.isEmpty else { return [] }
        let now = Date()
        return try await query.run { scope in
            let articles = try await scope.article.resolve(ids: ids)
            let metadataByID = Dictionary(
                uniqueKeysWithValues: try await scope.metadata
                    .resolveDetails(
                        referenceType: "news.article",
                        referenceIDs: articles.items.map(\.id)
                    )
                    .filter { $0.isPublic(at: now) }
                    .map { ($0.referenceID, $0) }
            )
            let publicArticles = articles.items.filter {
                metadataByID[$0.id] != nil
            }
            let categoriesByArticleID = try await scope.article.categoryIDs(
                for: publicArticles.map(\.id)
            )
            return publicArticles.compactMap { article in
                guard let metadata = metadataByID[article.id] else {
                    return nil
                }
                return .init(
                    id: article.id,
                    title: article.title,
                    excerpt: article.excerpt,
                    imageAssetId: article.imageAssetId,
                    imageURL: "",
                    media: nil,
                    metadata: metadata,
                    readingTime: NewsReadingTime.minutes(for: article.content),
                    categoryIDs: categoriesByArticleID[article.id] ?? []
                )
            }
        }
    }

    public func executeRelated(
        categoryIDs: [String],
        excludingArticleID: String,
        limit: Int = 6
    ) async throws -> [PublicNewsArticleSummary] {
        let categoryIDs = Array(Set(categoryIDs)).filter { !$0.isEmpty }
        guard !categoryIDs.isEmpty, limit > 0 else { return [] }
        let now = Date()
        return try await query.run { scope in
            let articles = try await scope.article.listPublicRelated(
                categoryIDs: categoryIDs,
                excludingArticleID: excludingArticleID,
                limit: limit
            )
            let metadataByID = Dictionary(
                uniqueKeysWithValues: try await scope.metadata
                    .resolveDetails(
                        referenceType: "news.article",
                        referenceIDs: articles.items.map(\.id)
                    )
                    .filter { $0.isPublic(at: now) }
                    .map { ($0.referenceID, $0) }
            )
            let categoryIDsByArticleID = try await scope.article.categoryIDs(
                for: articles.items.map(\.id)
            )
            return articles.items.compactMap { item in
                guard let metadata = metadataByID[item.id] else { return nil }
                return PublicNewsArticleSummary(
                    id: item.id,
                    title: item.title,
                    excerpt: item.excerpt,
                    imageAssetId: item.imageAssetId,
                    imageURL: "",
                    media: nil,
                    metadata: metadata,
                    readingTime: NewsReadingTime.minutes(for: item.content),
                    categoryIDs: categoryIDsByArticleID[item.id] ?? []
                )
            }
        }
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
                normalizedSearch =
                    trimmedSearch.isEmpty
                    ? nil
                    : trimmedSearch
            }
            else {
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
                    sort: [],
                    search: normalizedSearch
                ),
                categoryID: nil
            )
            let metadataByID = Dictionary(
                uniqueKeysWithValues: try await scope.metadata
                    .resolveDetails(
                        referenceType: "news.article",
                        referenceIDs: articles.items.map(\.id)
                    )
                    .filter { $0.isPublic(at: now) }
                    .map { ($0.referenceID, $0) }
            )
            let publicItems = articles.items.filter {
                metadataByID[$0.id] != nil
            }
            let categoryIDsByArticleID = try await scope.article.categoryIDs(
                for: publicItems.map(\.id)
            )
            return .init(
                items: publicItems.compactMap { item in
                    guard let metadata = metadataByID[item.id] else {
                        return nil
                    }
                    return .init(
                        id: item.id,
                        title: item.title,
                        excerpt: item.excerpt,
                        imageAssetId: item.imageAssetId,
                        imageURL: "",
                        media: nil,
                        metadata: metadata,
                        readingTime: NewsReadingTime.minutes(for: item.content),
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
