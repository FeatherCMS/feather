//
//  ArticleDatabaseQueries.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherInfrastructure
import NewsApplication
import WebApplication
import WebDomain

extension ArticleTable.Row {
    var asQueryListItem: ArticleList.Item {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            imageAssetId: imageAssetId,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    func asDetail(
        metadata: MetadataDetail,
        categoryIds: [String]
    ) -> ArticleDetail {
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

public struct ArticleDatabaseQueries: ArticleQueries {

    public let context: DatabaseQueryContext
    public var metadata: any MetadataQueries

    public init(
        context: DatabaseQueryContext,
        metadata: any MetadataQueries
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
        _ query: ArticleList.Query
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
    ) async throws -> ArticleDetail {
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

    public func list(
        query: ArticleList.Query
    ) async throws -> ArticleList {
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

    public func count(
        query: ArticleList.Query
    ) async throws -> Int {
        let table = ArticleTable(connection: context.connection)
        return try await table.count(search: query.search)
    }
}
