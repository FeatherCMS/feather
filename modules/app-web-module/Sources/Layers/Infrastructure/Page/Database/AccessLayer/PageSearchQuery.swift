import FeatherApplication
import FeatherDBAL
import FeatherDatabase
public import FeatherInfrastructure
public import WebApplication
import WebDomain
public import WebModule

extension Page.Table.List {
    var asSearchItem: Page.Search.Output.Item {
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

extension Page.Search.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(
            query: Page.Search.Input.Query
        ) async throws -> Page.Search.Output {
            let page = query.page.normalized()
            let offset = (page.number - 1) * page.size
            let items = try await context.connection
                .run(
                    query: searchPagesQuery(
                        search: query.search,
                        orderBy: orderByPage(query),
                        limit: page.size,
                        offset: offset
                    )
                ) { sequence in
                    try await sequence.collect().map(Page.Table.List.init(row:))
                }
                .map(\.asSearchItem)

            let total = try await context.connection.run(
                query: countPagesQuery(search: query.search)
            ) { sequence in
                guard let row = try await sequence.first() else { return 0 }
                return try row.decode(column: "count", as: Int.self)
            }
            return .init(items: items, total: total)
        }

        private func searchPagesQuery(
            search: String?,
            orderBy: String,
            limit: Int,
            offset: Int
        ) -> DatabaseQuery {
            // Keep this as a parameterized DBAL query: the typed SELECT builder
            // cannot currently express the correlated publication-date sort
            // with NULLS LAST used by public page ordering.
            var sql = DatabaseQuery.StringInterpolation(
                literalCapacity: 640,
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

        private func orderByPage(_ query: Page.Search.Input.Query) -> String {
            let sortParts = query.sort.map { sort in
                let column: String
                switch sort.field {
                case .id: column = "id"
                case .title: column = "title"
                case .createdAt: column = "created_at"
                case .updatedAt: column = "updated_at"
                }
                let direction = sort.direction == .asc ? "ASC" : "DESC"
                return "\(column) \(direction)"
            }
            return "(SELECT publication_date FROM web_metadata "
                + "WHERE reference_type = 'web.page' "
                + "AND reference_id = web_page.id) "
                + "DESC NULLS LAST"
                + (sortParts + ["id ASC"]).joined(separator: ", ")
        }
    }
}
