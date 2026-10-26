import FeatherApplication
import FeatherDBAL
import FeatherDatabase
import FeatherInfrastructure
import WebApplication
import WebModule

extension Page.Search.Query {
    struct AccessLayer {
        let connection: any DatabaseConnection

        func searchPages(
            search: String?,
            query: Page.Search.Input.Query,
            limit: Int,
            offset: Int
        ) -> DatabaseQuery {
            searchPagesQuery(
                search: search,
                orderBy: orderByPage(query),
                limit: limit,
                offset: offset
            )
        }

        func countPages(search: String?) -> DatabaseQuery {
            var sql = DatabaseQuery.StringInterpolation(
                literalCapacity: 500,
                interpolationCount: 5
            )
            sql.appendLiteral("SELECT COUNT(*) AS count FROM web_page WHERE (")
            appendSearchFilter(to: &sql, search: search)
            sql.appendLiteral(";")
            return DatabaseQuery(stringInterpolation: sql)
        }

        private func searchPagesQuery(
            search: String?,
            orderBy: String,
            limit: Int,
            offset: Int
        ) -> DatabaseQuery {
            // Keep this parameterized DBAL query: the typed SELECT builder cannot
            // express the correlated publication-date sort with NULLS LAST.
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
                + ", "
                + (sortParts + ["id ASC"]).joined(separator: ", ")
        }
    }
}
