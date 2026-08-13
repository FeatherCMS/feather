//
//  AuthorDatabaseQueries.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import BlogApplication
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherInfrastructure
import WebApplication
import WebDomain

extension AuthorTable.Row {

    var asQueryListItem: AuthorList.Item {
        .init(
            id: id,
            name: name,
            excerpt: excerpt,
            profileImageAssetId: profileImageAssetId,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    func asDetail(
        metadata: MetadataDetail
    ) -> AuthorDetail {
        .init(
            id: id,
            name: name,
            excerpt: excerpt,
            content: content,
            profileImageAssetId: profileImageAssetId,
            metadata: metadata,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct AuthorDatabaseQueries: AuthorQueries {

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

    func orderByAuthor(
        _ query: AuthorList.Query
    ) -> String {
        let sortParts = query.sort.map { author -> String in
            let column: String
            switch author.field {
            case .id:
                column = "id"
            case .name:
                column = "name"
            case .createdAt:
                column = "created_at"
            case .updatedAt:
                column = "updated_at"
            }
            return "\(column) \(sortDirectionSQL(author.direction))"
        }
        return (sortParts + ["id ASC"]).joined(separator: ", ")
    }

    public func find(
        id: String
    ) async throws -> AuthorDetail {
        let table = AuthorTable(connection: context.connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        guard
            let metadata = try await metadata.find(
                referenceType: "blog.author",
                referenceID: id
            )
        else {
            throw RepositoryError.notFound
        }
        return row.asDetail(metadata: metadata)
    }

    public func list(
        query: AuthorList.Query
    ) async throws -> AuthorList {
        let page = pageSizeOffset(query.page)
        let table = AuthorTable(connection: context.connection)
        let items =
            try await table.list(
                search: query.search,
                orderBy: orderByAuthor(query),
                limit: page.size,
                offset: page.offset
            )
            .map(\.asQueryListItem)

        return .init(items: items)
    }

    public func count(
        query: AuthorList.Query
    ) async throws -> Int {
        let table = AuthorTable(connection: context.connection)
        return try await table.count(search: query.search)
    }
}
