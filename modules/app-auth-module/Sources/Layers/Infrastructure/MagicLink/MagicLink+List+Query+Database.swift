public import AuthApplication
public import AuthModule
import FeatherApplication
import FeatherDatabase
public import FeatherInfrastructure
import Foundation

extension MagicLink.List.Query {
    public struct Database: Interface {
        private struct Row {
            let id: String
            let authEmailId: String
            let token: String
            let expiresAt: Date
            let isPersistent: Bool
            let isUsed: Bool
            let createdAt: Date
            let updatedAt: Date

            init(from row: any DatabaseRow) throws {
                id = try row.decode(column: "id", as: String.self)
                authEmailId = try row.decode(
                    column: "auth_email_id",
                    as: String.self
                )
                token = try row.decode(column: "token", as: String.self)
                expiresAt = try row.decode(column: "expires_at", as: Date.self)
                isPersistent = try row.decode(
                    column: "is_persistent",
                    as: Bool.self
                )
                isUsed = try row.decode(column: "is_used", as: Bool.self)
                createdAt = try row.decode(column: "created_at", as: Date.self)
                updatedAt = try row.decode(column: "updated_at", as: Date.self)
            }

            var item: MagicLink.List.Output.Item {
                .init(
                    id: id,
                    authEmailId: authEmailId,
                    token: token,
                    expiresAt: expiresAt,
                    isPersistent: isPersistent,
                    isUsed: isUsed,
                    createdAt: createdAt,
                    updatedAt: updatedAt
                )
            }
        }

        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        private func pageSizeOffset(
            _ page: Search.Page
        ) -> (size: Int, offset: Int) {
            let page = page.normalized()
            let number = page.number - 1
            let offset =
                number > Int.max / page.size ? Int.max : number * page.size
            return (page.size, offset)
        }

        private func orderBy(_ query: MagicLink.List.Input.Query) -> String {
            let parts = query.sort.map { rule in
                "id \(rule.direction == .asc ? "ASC" : "DESC")"
            }
            return (parts + ["id ASC"]).joined(separator: ", ")
        }

        public func list(
            query: MagicLink.List.Input.Query
        ) async throws -> MagicLink.List.Output {
            let page = pageSizeOffset(query.page)
            let rows = try await context.connection.run(
                query: #"""
                    SELECT magic_link.*
                    FROM auth_magic_link AS magic_link
                    INNER JOIN auth_email AS email ON email.id=magic_link.auth_email_id
                    WHERE (\#(query.userId == nil)
                        OR email.identity_id=\#(query.userId ?? ""))
                    AND (\#(query.search == nil)
                        OR LOWER(magic_link.id) LIKE '%' || LOWER(\#(query.search ?? "")) || '%'
                        OR LOWER(magic_link.auth_email_id) LIKE '%' || LOWER(\#(query.search ?? "")) || '%'
                        OR LOWER(magic_link.token) LIKE '%' || LOWER(\#(query.search ?? "")) || '%'
                        OR CAST(magic_link.expires_at AS TEXT) LIKE '%' || \#(query.search ?? "") || '%'
                        OR LOWER(CAST(magic_link.is_persistent AS TEXT)) LIKE '%' || LOWER(\#(query.search ?? "")) || '%'
                        OR LOWER(CAST(magic_link.is_used AS TEXT)) LIKE '%' || LOWER(\#(query.search ?? "")) || '%')
                    ORDER BY \#(unescaped: orderBy(query))
                    LIMIT \#(page.size) OFFSET \#(page.offset);
                    """#
            ) { rows in
                try await rows.collect().map { try Row(from: $0).item }
            }
            return .init(items: rows)
        }

        public func count(query: MagicLink.List.Input.Query) async throws -> Int
        {
            try await context.connection.run(
                query: #"""
                    SELECT COUNT(*) AS count
                    FROM auth_magic_link AS magic_link
                    INNER JOIN auth_email AS email ON email.id=magic_link.auth_email_id
                    WHERE (\#(query.userId == nil)
                        OR email.identity_id=\#(query.userId ?? ""))
                    AND (\#(query.search == nil)
                        OR LOWER(magic_link.id) LIKE '%' || LOWER(\#(query.search ?? "")) || '%'
                        OR LOWER(magic_link.auth_email_id) LIKE '%' || LOWER(\#(query.search ?? "")) || '%'
                        OR LOWER(magic_link.token) LIKE '%' || LOWER(\#(query.search ?? "")) || '%'
                        OR CAST(magic_link.expires_at AS TEXT) LIKE '%' || \#(query.search ?? "") || '%'
                        OR LOWER(CAST(magic_link.is_persistent AS TEXT)) LIKE '%' || LOWER(\#(query.search ?? "")) || '%'
                        OR LOWER(CAST(magic_link.is_used AS TEXT)) LIKE '%' || LOWER(\#(query.search ?? "")) || '%');
                    """#
            ) { rows in
                guard let row = try await rows.collect().first else { return 0 }
                return try row.decode(column: "count", as: Int.self)
            }
        }
    }
}
