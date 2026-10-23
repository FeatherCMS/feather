//
//  ArticleDatabaseQueries.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import NewsApplication
import NewsDomain
public import NewsModule
public import WebApplication
import WebDomain
public import WebModule

extension ArticleQueries.Row {
    var asQueryListItem: Article.List.Output.Item {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

}

extension Article.Table.Detail {
    func asDetail(
        metadata: WebModule.Metadata.Snapshot,
        categoryIds: [String]
    ) -> Article.Detail.Output {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            categoryIds: categoryIds,
            metadata: metadata,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct ArticleDatabaseQueries: Article.Detail.Query.Interface,
    Article.List.Query.Interface,
    Article.Search.Query.Interface,
    NewsApplication.Public.Article.List.Query.Interface,
    NewsApplication.Public.Article.Search.Query.Interface,
    NewsApplication.Public.Article.Resolve.Query.Interface,
    NewsApplication.Public.Article.CategoryIDs.Query.Interface,
    NewsApplication.Public.Article.Related.Query.Interface
{

    public let context: DatabaseQueryContext
    public var metadata: any WebModule.Metadata.Reference.Query.Interface

    public init(
        context: DatabaseQueryContext,
        metadata: any WebModule.Metadata.Reference.Query.Interface
    ) {
        self.context = context
        self.metadata = metadata
    }

    func sortDirectionSQL(
        _ direction: Search.SortDirection
    ) -> String {
        switch direction {
        case .asc:
            "ASC"
        case .desc:
            "DESC"
        }
    }

    func orderByArticle(
        _ query: Article.List.Input.Query
    ) -> String {
        let sortParts = query.sort.map { article -> String in
            let column: String
            switch article.field {
            case .id:
                column = "id"
            case .title:
                column = "title"
            case .createdAt:
                column = "created_at"
            case .updatedAt:
                column = "updated_at"
            }
            return "\(column) \(sortDirectionSQL(article.direction))"
        }
        let defaultPublicationOrder =
            "(SELECT publication_date FROM web_metadata "
            + "WHERE reference_type = 'news.article' "
            + "AND reference_id = news_article.id) "
            + "DESC NULLS LAST"
        return (sortParts + [defaultPublicationOrder, "id ASC"])
            .joined(separator: ", ")
    }

    public func find(
        id: String
    ) async throws -> Article.Detail.Output {
        let accessLayer = DatabaseAccessLayer<Article.Table>(context: context)
        guard let row = try await accessLayer.selectFirst(by: \.id, equals: id) else {
            throw RepositoryError.notFound
        }
        let categoryIds = try await ArticleCategoryTable(context: context)
        .listCategoryIDs(articleID: id)
        guard
            let metadata = try await metadata.find(
                referenceType: "news.article",
                referenceID: id
            )
        else {
            throw RepositoryError.notFound
        }
        return row.asDetail(
            metadata: metadata,
            categoryIds: categoryIds
        )
    }

    public func categoryIDs(
        for articleIDs: [String]
    ) async throws -> [String: [String]] {
        try await ArticleCategoryTable(context: context)
            .listCategoryIDs(articleIDs: articleIDs)
    }

    public func resolve(
        ids: [String]
    ) async throws -> NewsApplication.Public.Article.Resolve.Query.Output {
        guard !ids.isEmpty else { return .init(items: []) }
        let rows = try await DatabaseAccessLayer<Article.Table>(context: context)
            .select { $0.where(\.id, in: ids) }
        let itemsByID = Dictionary(uniqueKeysWithValues: rows.map {
            ($0.id, NewsApplication.Public.Article.Item(
                id: $0.id,
                title: $0.title,
                excerpt: $0.excerpt,
                content: $0.content,
                imageAssetId: $0.imageAssetId,
                createdAt: $0.createdAt,
                updatedAt: $0.updatedAt
            ))
        })
        return .init(items: ids.compactMap { itemsByID[$0] })
    }

    public func list(
        query: Article.List.Input.Query
    ) async throws -> Article.List.Output {
        let page = query.page.normalized()
        let pageIndex = page.number - 1
        let offset =
            pageIndex > Int.max / page.size
            ? Int.max
            : pageIndex * page.size
        let queries = ArticleQueries(connection: context.connection)
        let items =
            try await queries.list(
                search: query.search,
                orderBy: orderByArticle(query),
                limit: page.size,
                offset: offset
            )
            .map(\.asQueryListItem)

        return .init(items: items)
    }

    public func search(
        query: Article.Search.Input.Query
    ) async throws -> Article.Search.Output {
        let listQuery = Article.List.Input.Query(
            page: query.page,
            sort: query.sort.map {
                .init(
                    field: .init(rawValue: $0.field.rawValue) ?? .id,
                    direction: $0.direction
                )
            },
            search: query.search
        )
        let result = try await list(query: listQuery)
        let total = try await count(query: listQuery)
        return .init(
            items: result.items.map {
                .init(
                    id: $0.id,
                    title: $0.title,
                    excerpt: $0.excerpt,
                    content: $0.content,
                    imageAssetId: $0.imageAssetId,
                    createdAt: $0.createdAt,
                    updatedAt: $0.updatedAt
                )
            },
            total: total
        )
    }

    public func listPublic(
        query: Article.List.Input.Query,
        categoryID: String?
    ) async throws -> NewsApplication.Public.Article.List.Query.Output {
        let page = query.page.normalized()
        let pageIndex = page.number - 1
        let offset =
            pageIndex > Int.max / page.size
            ? Int.max
            : pageIndex * page.size
        let queries = ArticleQueries(connection: context.connection)
        let items =
            try await queries.listPublic(
                search: query.search,
                categoryID: categoryID,
                orderBy: orderByArticle(query),
                limit: page.size,
                offset: offset
            )
            .map {
                NewsApplication.Public.Article.Item(
                    id: $0.id,
                    title: $0.title,
                    excerpt: $0.excerpt,
                    content: $0.content,
                    imageAssetId: $0.imageAssetId,
                    createdAt: $0.createdAt,
                    updatedAt: $0.updatedAt
                )
            }

        return .init(items: items)
    }

    public func countPublic(
        query: Article.Search.Input.Query,
        categoryID: String?
    ) async throws -> Int {
        try await ArticleQueries(connection: context.connection).countPublic(
            search: query.search,
            categoryID: categoryID
        )
    }

    public func searchPublic(
        query: NewsApplication.Public.Article.Search.Input.Query
    ) async throws -> NewsApplication.Public.Article.Search.Query.Output {
        let articles = try await listPublic(
            query: .init(
                page: .init(size: query.pageSize, number: query.pageNumber),
                sort: [],
                search: query.search
            ),
            categoryID: nil
        )
        return .init(items: articles.items)
    }

    public func countPublic(
        query: NewsApplication.Public.Article.Search.Input.Query
    ) async throws -> Int {
        try await countPublic(
            query: Article.List.Input.Query(search: query.search),
            categoryID: nil
        )
    }

    public func listPublicRelated(
        categoryIDs: [String],
        excludingArticleID: String,
        limit: Int
    ) async throws -> NewsApplication.Public.Article.Related.Query.Output {
        let categoryIDs = Array(Set(categoryIDs)).filter { !$0.isEmpty }
            .sorted()
        guard !categoryIDs.isEmpty, limit > 0 else { return .init(items: []) }
        let items = try await ArticleQueries(connection: context.connection)
            .listPublicRelated(
                categoryIDs: categoryIDs,
                excludingArticleID: excludingArticleID,
                limit: limit,
                orderBy: orderByArticle(.init())
            )
            .map {
                NewsApplication.Public.Article.Item(
                    id: $0.id,
                    title: $0.title,
                    excerpt: $0.excerpt,
                    content: $0.content,
                    imageAssetId: $0.imageAssetId,
                    createdAt: $0.createdAt,
                    updatedAt: $0.updatedAt
                )
            }
        return .init(items: items)
    }

    public func count(
        query: Article.List.Input.Query
    ) async throws -> Int {
        try await DatabaseAccessLayer<Article.Table>(context: context)
            .selectCount { initial in
                guard let search = query.search else { return initial }
                return initial.where(
                    searchText: search,
                    columns: [
                        DatabaseQueryTextColumn<Article.Table>(\.id),
                        DatabaseQueryTextColumn<Article.Table>(\.title),
                        DatabaseQueryTextColumn<Article.Table>(\.excerpt),
                        DatabaseQueryTextColumn<Article.Table>(\.content),
                    ]
                )
            }
    }

    public func countPublic(
        query: Article.List.Input.Query,
        categoryID: String?
    ) async throws -> Int {
        let queries = ArticleQueries(connection: context.connection)
        return try await queries.countPublic(
            search: query.search,
            categoryID: categoryID
        )
    }
}
