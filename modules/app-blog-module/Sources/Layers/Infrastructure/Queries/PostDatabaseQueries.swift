//
//  PostDatabaseQueries.swift
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

extension PostTable.Row {

    var asQueryListItem: PostList.Item {
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
    ) -> PostDetail {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            authorIds: authorIds,
            tagIds: tagIds,
            metadata: metadata,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct PostDatabaseQueries: PostQueries {

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

    func orderByPost(
        _ query: PostList.Query
    ) -> String {
        let sortParts = query.sort.map { post -> String in
            let column: String
            switch post.field {
            case .id:
                column = "id"
            case .title:
                column = "title"
            case .createdAt:
                column = "created_at"
            case .updatedAt:
                column = "updated_at"
            }
            return "\(column) \(sortDirectionSQL(post.direction))"
        }
        return (sortParts + ["id ASC"]).joined(separator: ", ")
    }

    public func find(
        id: String
    ) async throws -> PostDetail {
        let table = PostTable(connection: context.connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        guard
            let metadata = try await metadata.find(
                referenceType: "blog.post",
                referenceID: id
            )
        else {
            throw RepositoryError.notFound
        }
        return row.asDetail(metadata: metadata)
    }

    public func list(
        query: PostList.Query
    ) async throws -> PostList {
        let page = pageSizeOffset(query.page)
        let table = PostTable(connection: context.connection)
        let items =
            try await table.list(
                search: query.search,
                orderBy: orderByPost(query),
                limit: page.size,
                offset: page.offset
            )
            .map(\.asQueryListItem)

        return .init(items: items)
    }

    public func count(
        query: PostList.Query
    ) async throws -> Int {
        let table = PostTable(connection: context.connection)
        return try await table.count(search: query.search)
    }
}
