//
//  CategoryDatabaseQueries.swift
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

extension CategoryTable.Row {
    var asQueryListItem: Category.List.Output.Item {
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
        metadata: WebModule.Metadata.Snapshot
    ) -> Category.Detail.Output {
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

public struct CategoryDatabaseQueries: Category.Detail.Query.Interface,
    Category.List.Query.Interface,
    Category.Search.Query.Interface,
    PublicNewsArticle.Detail.Query.Interface
{

    public let context: DatabaseQueryContext
    public var metadata: any WebModule.Metadata.Reference.Query.Interface
    public var metadataResolver:
        any WebModule.Metadata.Resolve.Detail.Query.Interface

    public init(
        context: DatabaseQueryContext,
        metadata: any WebModule.Metadata.Reference.Query.Interface
            & WebModule.Metadata.Resolve.Detail.Query.Interface
    ) {
        self.context = context
        self.metadata = metadata
        self.metadataResolver = metadata
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
        _ query: Category.List.Input.Query
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
    ) async throws -> Category.Detail.Output {
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

    public func findCategories(
        ids: [String]
    ) async throws -> [Category.Detail.Output] {
        guard !ids.isEmpty else { return [] }
        let rows = try await CategoryTable(connection: context.connection)
            .list(ids: ids)
        let details = try await resolveNewsMetadataDetails(
            metadata: metadataResolver,
            referenceType: "news.category",
            referenceIDs: ids
        )
        let metadataByID = Dictionary(
            uniqueKeysWithValues: details.map { ($0.referenceID, $0) }
        )
        return rows.compactMap { row in
            guard let detail = metadataByID[row.id] else { return nil }
            return row.asDetail(metadata: detail)
        }
    }

    public func list(
        query: Category.List.Input.Query
    ) async throws -> Category.List.Output {
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

    public func search(
        query: Category.Search.Input.Query
    ) async throws -> Category.Search.Output {
        let listQuery = Category.List.Input.Query(
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
                    imageAssetId: $0.imageAssetId,
                    createdAt: $0.createdAt,
                    updatedAt: $0.updatedAt
                )
            },
            total: total
        )
    }

    public func count(
        query: Category.List.Input.Query
    ) async throws -> Int {
        let table = CategoryTable(connection: context.connection)
        return try await table.count(search: query.search)
    }
}
