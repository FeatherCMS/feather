import FeatherApplication
import FeatherDBAL
import FeatherDatabase
import NewsApplication
import NewsModule

extension Article.Search.Query {
    struct AccessLayer {
        let connection: any DatabaseConnection

        func searchArticles(
            search: String?,
            status: String?,
            query: Article.Search.Input.Query,
            limit: Int,
            offset: Int
        ) -> DatabaseQuery {
            var sql = DatabaseQuery.StringInterpolation(
                literalCapacity: 640,
                interpolationCount: 8
            )
            sql.appendLiteral(
                "SELECT id, title, excerpt, content, image_asset_id, created_at, updated_at FROM news_article WHERE ("
            )
            appendSearchFilter(to: &sql, search: search)
            appendStatusFilter(to: &sql, status: status)
            sql.appendLiteral(") ORDER BY ")
            let sortParts = query.sort.map { rule in
                let column: String
                switch rule.field {
                case .id: column = "id"
                case .title: column = "title"
                case .publicationDate:
                    column =
                        "(SELECT publication_date FROM web_metadata "
                        + "WHERE reference_type = 'news.article' "
                        + "AND reference_id = news_article.id)"
                case .createdAt: column = "created_at"
                case .updatedAt: column = "updated_at"
                }
                let direction = rule.direction == .asc ? "ASC" : "DESC"
                let nulls = rule.field == .publicationDate ? " NULLS LAST" : ""
                return "\(column) \(direction)\(nulls)"
            }
            let tieBreakers = query.sort.contains(where: { $0.field == .id })
                ? sortParts
                : sortParts + ["id ASC"]
            sql.appendLiteral(tieBreakers.joined(separator: ", "))
            sql.appendLiteral(" LIMIT ")
            sql.appendInterpolation(limit)
            sql.appendLiteral(" OFFSET ")
            sql.appendInterpolation(offset)
            sql.appendLiteral(";")
            return DatabaseQuery(stringInterpolation: sql)
        }

        func countArticles(search: String?, status: String?) -> DatabaseQuery {
            var sql = DatabaseQuery.StringInterpolation(
                literalCapacity: 480,
                interpolationCount: 5
            )
            sql.appendLiteral("SELECT COUNT(*) AS count FROM news_article WHERE (")
            appendSearchFilter(to: &sql, search: search)
            appendStatusFilter(to: &sql, status: status)
            sql.appendLiteral(");")
            return DatabaseQuery(stringInterpolation: sql)
        }

        private func appendStatusFilter(
            to sql: inout DatabaseQuery.StringInterpolation,
            status: String?
        ) {
            guard let status else { return }
            sql.appendLiteral(
                " AND EXISTS (SELECT 1 FROM web_metadata WHERE reference_type = 'news.article' AND reference_id = news_article.id AND status = "
            )
            sql.appendInterpolation(status)
            sql.appendLiteral(")")
        }

        private func appendSearchFilter(
            to sql: inout DatabaseQuery.StringInterpolation,
            search: String?
        ) {
            sql.appendLiteral("(")
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
