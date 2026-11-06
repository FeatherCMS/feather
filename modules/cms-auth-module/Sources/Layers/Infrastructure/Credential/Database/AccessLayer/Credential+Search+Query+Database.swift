public import AuthApplication
public import AuthModule
import FeatherApplication
import FeatherDBAL
import FeatherDatabase
public import FeatherInfrastructure
import Foundation

extension Credential.Search.Query {
    public struct Database: Interface {
        private struct Row {
            let id: String
            let userId: String
            let identityName: String?
            let email: String
            let createdAt: Date
            let updatedAt: Date

            init(from row: any DatabaseRow) throws {
                id = try row.decode(column: "id", as: String.self)
                userId = try row.decode(column: "user_id", as: String.self)
                identityName = try row.decode(
                    column: "identity_name",
                    as: String?.self
                )
                email = try row.decode(column: "email", as: String.self)
                createdAt = try row.decode(column: "created_at", as: Date.self)
                updatedAt = try row.decode(column: "updated_at", as: Date.self)
            }

            var item: Credential.Search.Output.Item {
                .init(
                    id: id,
                    userId: userId,
                    identityName: identityName ?? userId,
                    email: email,
                    createdAt: createdAt,
                    updatedAt: updatedAt
                )
            }
        }

        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(
            query: Credential.Search.Input.Query,
            userId: String?
        ) async throws -> Credential.Search.Output {
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            let orderBy =
                query.sort.map { rule in
                    let column =
                        switch rule.field {
                        case .userId: "user_id"
                        case .email: "email"
                        }
                    let direction = rule.direction == .asc ? "ASC" : "DESC"
                    return "\(column) \(direction)"
                } + ["user_id ASC", "email ASC"]
            let orderBySQL = orderBy.joined(separator: ", ")
            let items = try await context.connection.run(
                query: #"""
                    SELECT credential.id, email.identity_id AS user_id,
                        identity.name AS identity_name, email.email,
                        credential.created_at, credential.updated_at
                    FROM auth_email_credential AS credential
                    INNER JOIN auth_email AS email
                        ON email.id = credential.auth_email_id
                    INNER JOIN user_identity AS identity
                        ON identity.id = email.identity_id
                    WHERE (\#(userId == nil) OR email.identity_id = \#(userId ?? ""))
                        AND (\#(query.search == nil)
                            OR LOWER(credential.id) LIKE '%' || LOWER(\#(query.search ?? "")) || '%'
                            OR LOWER(email.identity_id) LIKE '%' || LOWER(\#(query.search ?? "")) || '%'
                            OR LOWER(COALESCE(identity.name, '')) LIKE '%' || LOWER(\#(query.search ?? "")) || '%'
                            OR LOWER(email.email) LIKE '%' || LOWER(\#(query.search ?? "")) || '%')
                    ORDER BY \#(unescaped: orderBySQL)
                    LIMIT \#(page.size) OFFSET \#(offset);
                    """#
            ) { rows in
                try await rows.collect().map { try Row(from: $0).item }
            }
            let total = try await context.connection.run(
                query: #"""
                    SELECT COUNT(*) AS count
                    FROM auth_email_credential AS credential
                    INNER JOIN auth_email AS email
                        ON email.id = credential.auth_email_id
                    INNER JOIN user_identity AS identity
                        ON identity.id = email.identity_id
                    WHERE (\#(userId == nil) OR email.identity_id = \#(userId ?? ""))
                        AND (\#(query.search == nil)
                            OR LOWER(credential.id) LIKE '%' || LOWER(\#(query.search ?? "")) || '%'
                            OR LOWER(email.identity_id) LIKE '%' || LOWER(\#(query.search ?? "")) || '%'
                            OR LOWER(COALESCE(identity.name, '')) LIKE '%' || LOWER(\#(query.search ?? "")) || '%'
                            OR LOWER(email.email) LIKE '%' || LOWER(\#(query.search ?? "")) || '%');
                    """#
            ) { rows in
                guard let row = try await rows.collect().first else { return 0 }
                return try row.decode(column: "count", as: Int.self)
            }
            return .init(items: items, total: total)
        }
    }
}
