public import FeatherApplication
public import FeatherModuleKit
import Foundation
import NewsDomain
import NewsModule
import WebApplication
import WebDomain
import WebModule

extension Public.Category.Detail {
    public struct UseCase: FeatherApplication.UseCase {
        let query: any QueryExecutor<Scope>

        public init(
            query: any QueryExecutor<Scope>
        ) {
            self.query = query
        }

        public func execute(
            input: Input
        ) async throws -> Output {
            let now = Date()
            return try await query.run { scope in
                let category = try await scope.category.find(id: input.id)
                guard category.metadata.isDirectlyAccessible(at: now) else {
                    throw Error(message: "Category not found")
                }
                let articles = try await Self.publicArticles(
                    matchingCategoryID: input.id,
                    now: now,
                    context: scope,
                    pageNumber: input.pageNumber,
                    pageSize: input.pageSize
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
}

extension Public.Category.Detail.UseCase {
    fileprivate struct PublicArticlePage: Sendable {
        let items: [Public.Article.Summary.Item]
        let total: Int
        let page: Int
        let pageSize: Int
    }

    fileprivate static func publicArticles(
        matchingCategoryID categoryID: String,
        now: Date,
        context: Public.Category.Detail.Scope,
        pageNumber: Int,
        pageSize: Int
    ) async throws -> PublicArticlePage {
        let resolvedPageSize = max(1, pageSize)
        let requestedPage = max(1, pageNumber)
        async let totalTask = context.article.countPublicArticles(
            categoryID: categoryID
        )
        async let requestedArticlesTask = context.article.listPublicArticles(
            categoryID: categoryID,
            page: .init(size: resolvedPageSize, number: requestedPage)
        )
        let total = try await totalTask
        let requestedArticles = try await requestedArticlesTask
        let pageCount = max(
            1,
            (total + resolvedPageSize - 1) / resolvedPageSize
        )
        let currentPage = min(requestedPage, pageCount)
        let articleItems: [Public.Article.Item]
        if currentPage == requestedPage || total == 0 {
            articleItems = requestedArticles
        }
        else {
            articleItems = try await context.article.listPublicArticles(
                categoryID: categoryID,
                page: .init(size: resolvedPageSize, number: currentPage)
            )
        }
        async let categoryIDsTask = context.articleCategoryIDs.categoryIDs(
            for: articleItems.map(\.id)
        )
        async let metadataTask = context.metadataDetails.resolveDetails(
            referenceType: "news.article",
            referenceIDs: Array(Set(articleItems.map(\.id)))
        )
        let categoryIDsByArticleID = try await categoryIDsTask
        let metadata = try await metadataTask
        var metadataByArticleID: [String: WebModule.Metadata.Snapshot] = [:]
        for item in metadata {
            precondition(
                metadataByArticleID.updateValue(
                    item,
                    forKey: item.referenceID
                ) == nil
            )
        }
        var result: [Public.Article.Summary.Item] = []
        for item in articleItems {
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
                    readingTime: Public.Article.ReadingTime.minutes(
                        for: item.content
                    ),
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
