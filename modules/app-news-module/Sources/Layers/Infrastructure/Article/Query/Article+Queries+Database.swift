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

extension ArticleTable.Row {
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
    PublicNewsArticle.List.Query.Interface,
    PublicNewsArticle.Resolve.Query.Interface,
    PublicNewsArticle.CategoryIDs.Query.Interface,
    PublicNewsArticle.Related.Query.Interface
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

    func pageSizeOffset(
        _ page: Search.Page
    ) -> (size: Int, offset: Int) {
        let size = max(1, page.size)
        let number = max(1, page.number)
        return (size, (number - 1) * size)
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
        let table = ArticleTable(connection: context.connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        let categoryIds = try await ArticleCategoryTable(
            connection: context.connection
        )
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
        try await ArticleCategoryTable(connection: context.connection)
            .listCategoryIDs(articleIDs: articleIDs)
    }

    public func resolve(
        ids: [String]
    ) async throws -> PublicNewsArticle.Resolve.Output {
        guard !ids.isEmpty else { return .init(items: []) }
        let rows = try await ArticleTable(connection: context.connection)
            .resolve(ids: ids)
        let itemsByID = Dictionary(uniqueKeysWithValues: rows.map {
            ($0.id, PublicNewsArticle.Item(
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
        let page = pageSizeOffset(query.page)
        let table = ArticleTable(connection: context.connection)
        let items =
            try await table.list(
                search: query.search,
                orderBy: orderByArticle(query),
                limit: page.size,
                offset: page.offset
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
    ) async throws -> PublicNewsArticle.List.Query.Output {
        let page = pageSizeOffset(query.page)
        let table = ArticleTable(connection: context.connection)
        let items =
            try await table.listPublic(
                search: query.search,
                categoryID: categoryID,
                orderBy: orderByArticle(query),
                limit: page.size,
                offset: page.offset
            )
            .map {
                PublicNewsArticle.Item(
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

    public func listPublicRelated(
        categoryIDs: [String],
        excludingArticleID: String,
        limit: Int
    ) async throws -> PublicNewsArticle.Related.Output {
        let categoryIDs = Array(Set(categoryIDs)).filter { !$0.isEmpty }
            .sorted()
        guard !categoryIDs.isEmpty, limit > 0 else { return .init(items: []) }
        let items = try await ArticleTable(connection: context.connection)
            .listPublicRelated(
                categoryIDs: categoryIDs,
                excludingArticleID: excludingArticleID,
                limit: limit,
                orderBy: orderByArticle(.init())
            )
            .map {
                PublicNewsArticle.Item(
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
        let table = ArticleTable(connection: context.connection)
        return try await table.count(search: query.search)
    }

    public func countPublic(
        query: Article.List.Input.Query,
        categoryID: String?
    ) async throws -> Int {
        let table = ArticleTable(connection: context.connection)
        return try await table.countPublic(
            search: query.search,
            categoryID: categoryID
        )
    }
}
