//
//  GetPublicCategory.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
public import FeatherModuleKit
import Foundation
import NewsDomain
import NewsModule
import WebApplication
import WebDomain

public struct GetPublicCategory {
    let query: any QueryExecutor<PublicNewsCategory.Detail.Scope>

    public init(
        query: any QueryExecutor<PublicNewsCategory.Detail.Scope>
    ) {
        self.query = query
    }

    public func execute(
        id: String,
        pageNumber: Int = 1,
        pageSize: Int = 10000
    ) async throws -> PublicNewsCategory.Detail.Output {
        let now = Date()
        return try await query.run { scope in
            let category = try await scope.category.find(id: id)
            guard category.metadata.isDirectlyAccessible(at: now) else {
                throw Error(message: "Category not found")
            }
            let articles = try await Self.publicArticles(
                matchingCategoryID: id,
                now: now,
                context: scope,
                pageNumber: pageNumber,
                pageSize: pageSize
            )
            return .init(
                id: category.id,
                title: category.title,
                excerpt: category.excerpt,
                content: category.content,
                imageAssetId: category.imageAssetId,
                imageURL: "",
                media: nil,
                metadata: category.metadata,
                articles: articles.items,
                total: articles.total,
                page: articles.page,
                pageSize: articles.pageSize
            )
        }
    }
}

extension GetPublicCategory {
    fileprivate struct PublicArticlePage: Sendable {
        let items: [PublicNewsArticle.Summary.Item]
        let total: Int
        let page: Int
        let pageSize: Int
    }

    fileprivate static func publicArticles(
        matchingCategoryID categoryID: String,
        now: Date,
        context: PublicNewsCategory.Detail.Scope,
        pageNumber: Int,
        pageSize: Int
    ) async throws -> PublicArticlePage {
        let resolvedPageSize = max(1, pageSize)
        let requestedPage = max(1, pageNumber)
        async let totalTask = context.article.countPublic(
            query: .init(),
            categoryID: categoryID
        )
        async let requestedArticlesTask = context.article.listPublic(
            query: .init(
                page: .init(
                    size: resolvedPageSize,
                    number: requestedPage
                ),
                sort: []
            ),
            categoryID: categoryID
        )
        let (total, requestedArticles) = try await (
            totalTask,
            requestedArticlesTask
        )
        let pageCount = max(
            1,
            (total + resolvedPageSize - 1) / resolvedPageSize
        )
        let currentPage = min(requestedPage, pageCount)
        let articles: PublicNewsArticle.List.Query.Output
        if currentPage == requestedPage || total == 0 {
            articles = requestedArticles
        }
        else {
            articles = try await context.article.listPublic(
                query: .init(
                    page: .init(
                        size: resolvedPageSize,
                        number: currentPage
                    ),
                    sort: []
                ),
                categoryID: categoryID
            )
        }
        async let categoryIDsTask = context.articleCategoryIDs.categoryIDs(
            for: articles.items.map(\.id)
        )
        async let metadataTask = resolveNewsMetadataDetails(
            metadata: context.metadataDetails,
            referenceType: "news.article",
            referenceIDs: articles.items.map(\.id)
        )
        let (categoryIDsByArticleID, metadata) = try await (
            categoryIDsTask,
            metadataTask
        )
        let metadataByArticleID = Dictionary(
            uniqueKeysWithValues: metadata.map { ($0.referenceID, $0) }
        )
        var result: [PublicNewsArticle.Summary.Item] = []
        for item in articles.items {
            guard
                let metadata = metadataByArticleID[item.id],
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
                    categoryIDs: categoryIDsByArticleID[item.id] ?? []
                )
            )
        }
        return .init(
            items: result,
            total: total,
            page: currentPage,
            pageSize: resolvedPageSize
        )
    }
}
