//
//  Page.Query.Database.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherDBAL
import FeatherDatabase
public import FeatherInfrastructure
public import WebApplication
public import WebDomain

extension Page.Table.List {

    var asQueryListItem: PageList.Item {
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

extension Page.Table.Detail {
    func asDetail(
        metadata: MetadataDetail
    ) -> PageDetail {
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

extension Page.Query {
    public struct Database: Interface {

        public let context: DatabaseQueryContext
        public var metadata: any Metadata.Query.Interface

        public init(
            context: DatabaseQueryContext,
            metadata: any Metadata.Query.Interface
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

        func orderByPage(
            _ query: PageList.Query
        ) -> String {
            let sortParts = query.sort.map { page -> String in
                let column: String
                switch page.field {
                case .id:
                    column = "id"
                case .title:
                    column = "title"
                case .createdAt:
                    column = "created_at"
                case .updatedAt:
                    column = "updated_at"
                }
                return "\(column) \(sortDirectionSQL(page.direction))"
            }
            let defaultPublicationOrder =
                "(SELECT publication_date FROM web_metadata "
                + "WHERE reference_type = 'web.page' "
                + "AND reference_id = web_page.id) "
                + "DESC NULLS LAST"
            return (sortParts + [defaultPublicationOrder, "id ASC"])
                .joined(separator: ", ")
        }

        public func find(
            id: String
        ) async throws -> PageDetail {
            guard
                let row = try await DatabaseAccessLayer<Page.Table>(
                    context: context
                )
                .selectFirst(by: \.id, equals: id)
            else {
                throw RepositoryError.notFound
            }
            guard
                let metadata = try await metadata.find(
                    referenceType: "web.page",
                    referenceID: id
                )
            else {
                throw RepositoryError.notFound
            }
            return row.asDetail(metadata: metadata)
        }

        public func list(
            query: PageList.Query
        ) async throws -> PageList {
            let page = pageSizeOffset(query.page)
            let items = try await context.connection
                .run(
                    query: searchPagesQuery(
                        search: query.search,
                        orderBy: orderByPage(query),
                        limit: page.size,
                        offset: page.offset
                    )
                ) { sequence in
                    try await sequence.collect().map(Page.Table.List.init(row:))
                }
                .map(\.asQueryListItem)

            return .init(items: items)
        }

        public func count(
            query: PageList.Query
        ) async throws -> Int {
            try await context.connection.run(
                query: countPagesQuery(search: query.search)
            ) { sequence in
                guard let row = try await sequence.first() else { return 0 }
                return try row.decode(column: "count", as: Int.self)
            }
        }

        private func searchPagesQuery(
            search: String?,
            orderBy: String,
            limit: Int,
            offset: Int
        ) -> DatabaseQuery {
            var sql = DatabaseQuery.StringInterpolation(
                literalCapacity: 600,
                interpolationCount: 8
            )
            sql.appendLiteral(
                "SELECT id, title, excerpt, image_asset_id, created_at, updated_at FROM web_page WHERE ("
            )
            appendSearchFilter(to: &sql, search: search)
            sql.appendLiteral(" ORDER BY ")
            sql.appendLiteral(orderBy)
            sql.appendLiteral(" LIMIT ")
            sql.appendInterpolation(limit)
            sql.appendLiteral(" OFFSET ")
            sql.appendInterpolation(offset)
            sql.appendLiteral(";")
            return DatabaseQuery(stringInterpolation: sql)
        }

        private func countPagesQuery(search: String?) -> DatabaseQuery {
            var sql = DatabaseQuery.StringInterpolation(
                literalCapacity: 500,
                interpolationCount: 5
            )
            sql.appendLiteral("SELECT COUNT(*) AS count FROM web_page WHERE (")
            appendSearchFilter(to: &sql, search: search)
            sql.appendLiteral(");")
            return DatabaseQuery(stringInterpolation: sql)
        }

        private func appendSearchFilter(
            to sql: inout DatabaseQuery.StringInterpolation,
            search: String?
        ) {
            sql.appendInterpolation(search == nil)
            sql.appendLiteral(" OR LOWER(id) LIKE '%' || LOWER(")
            sql.appendInterpolation(search ?? "")
            sql.appendLiteral(") || '%' OR LOWER(title) LIKE '%' || LOWER(")
            sql.appendInterpolation(search ?? "")
            sql.appendLiteral(") || '%' OR LOWER(excerpt) LIKE '%' || LOWER(")
            sql.appendInterpolation(search ?? "")
            sql.appendLiteral(") || '%' OR LOWER(content) LIKE '%' || LOWER(")
            sql.appendInterpolation(search ?? "")
            sql.appendLiteral(") || '%')")
        }
    }
}
