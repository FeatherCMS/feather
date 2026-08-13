//
//  CategoryDatabaseQueries.swift
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

extension CategoryTable.Row {
    var asQueryListItem: CategoryList.Item {
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
        metadata: MetadataDetail
    ) -> CategoryDetail {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            metadata: metadata,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct CategoryDatabaseQueries: CategoryQueries {

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

    func orderByCategory(
        _ query: CategoryList.Query
    ) -> String {
        let sortParts = query.sort.map { category -> String in
            let column: String
            switch category.field {
            case .id:
                column = "id"
            case .title:
                column = "title"
            case .createdAt:
                column = "created_at"
            case .updatedAt:
                column = "updated_at"
            }
            return "\(column) \(sortDirectionSQL(category.direction))"
        }
        return (sortParts + ["id ASC"]).joined(separator: ", ")
    }

    public func find(
        id: String
    ) async throws -> CategoryDetail {
        let table = CategoryTable(connection: context.connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        guard
            let metadata = try await metadata.find(
                referenceType: "news.category",
                referenceID: id
            )
        else {
            throw RepositoryError.notFound
        }
        return row.asDetail(metadata: metadata)
    }

    public func list(
        query: CategoryList.Query
    ) async throws -> CategoryList {
        let page = pageSizeOffset(query.page)
        let table = CategoryTable(connection: context.connection)
        let items =
            try await table.list(
                search: query.search,
                orderBy: orderByCategory(query),
                limit: page.size,
                offset: page.offset
            )
            .map(\.asQueryListItem)

        return .init(items: items)
    }

    public func count(
        query: CategoryList.Query
    ) async throws -> Int {
        let table = CategoryTable(connection: context.connection)
        return try await table.count(search: query.search)
    }
}
