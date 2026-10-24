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

extension Category.Table.List {
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

}

extension Category.Table.Detail {
    func asDetail(metadata: WebModule.Metadata.Snapshot) -> Category.Detail.Output {
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
    NewsApplication.Public.Article.Detail.Query.Interface
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

    public func find(
        id: String
    ) async throws -> Category.Detail.Output {
        let accessLayer = DatabaseAccessLayer<Category.Table>(context: context)
        guard let row = try await accessLayer.selectFirst(by: \.id, equals: id) else {
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
    ) async throws -> NewsApplication.Public.Article.Detail.Query.Output {
        guard !ids.isEmpty else { return .init(items: []) }
        let rows = try await DatabaseAccessLayer<Category.Table>(context: context)
            .select { $0.where(\.id, in: ids).order(by: \.id) }
        let details = try await metadataResolver.resolveDetails(
            referenceType: "news.category",
            referenceIDs: Array(Set(ids))
        )
        let metadataByID = Dictionary(
            uniqueKeysWithValues: details.map { ($0.referenceID, $0) }
        )
        let items: [NewsApplication.Public.Article.Detail.Query.Item] = rows
            .compactMap {
                row -> NewsApplication.Public.Article.Detail.Query.Item? in
            guard let detail = metadataByID[row.id] else { return nil }
            return NewsApplication.Public.Article.Detail.Query.Item(
                id: row.id,
                title: row.title,
                excerpt: row.excerpt,
                imageAssetId: row.imageAssetId,
                metadata: detail
            )
            }
        return .init(items: items)
    }

    public func list(
        query: Category.List.Input.Query
    ) async throws -> Category.List.Output {
        let page = query.page.normalized()
        let pageIndex = page.number - 1
        let offset =
            pageIndex > Int.max / page.size
            ? Int.max
            : pageIndex * page.size
        let accessLayer = DatabaseAccessLayer<Category.Table>(context: context)
        let items = try await accessLayer
            .select(as: Category.Table.List.self) { initial in
                var result = initial
                if let search = query.search {
                    result = result.where(
                        searchText: search,
                        columns: [
                            DatabaseQueryTextColumn<Category.Table>(\.id),
                            DatabaseQueryTextColumn<Category.Table>(\.title),
                            DatabaseQueryTextColumn<Category.Table>(\.excerpt),
                            DatabaseQueryTextColumn<Category.Table>(\.content),
                        ]
                    )
                }
                var orders = query.sort.map { rule in
                    let direction: DatabaseQueryDirection =
                        rule.direction == .asc ? .ascending : .descending
                    return switch rule.field {
                    case .id:
                        DatabaseQueryOrder<Category.Table>(by: \.id, direction)
                    case .title:
                        DatabaseQueryOrder<Category.Table>(by: \.title, direction)
                    case .createdAt:
                        DatabaseQueryOrder<Category.Table>(by: \.createdAt, direction)
                    case .updatedAt:
                        DatabaseQueryOrder<Category.Table>(by: \.updatedAt, direction)
                    }
                }
                if !query.sort.contains(where: { $0.field == .id }) {
                    orders.append(.init(by: \.id, .ascending))
                }
                return result
                    .order(by: orders)
                    .limit(page.size)
                    .offset(offset)
            }
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
        try await DatabaseAccessLayer<Category.Table>(context: context)
            .selectCount { initial in
                guard let search = query.search else { return initial }
                return initial.where(
                    searchText: search,
                    columns: [
                        DatabaseQueryTextColumn<Category.Table>(\.id),
                        DatabaseQueryTextColumn<Category.Table>(\.title),
                        DatabaseQueryTextColumn<Category.Table>(\.excerpt),
                        DatabaseQueryTextColumn<Category.Table>(\.content),
                    ]
                )
            }
    }
}
