public import AuthApplication
public import AuthModule
import FeatherApplication
import FeatherDatabase
public import FeatherInfrastructure
import Foundation

extension Credential.Detail.Query {
    public struct Database: Interface {
        private struct Row {
            let id: String
            let userId: String
            let email: String
            let createdAt: Date
            let updatedAt: Date

            init(from row: any DatabaseRow) throws {
                id = try row.decode(column: "id", as: String.self)
                userId = try row.decode(column: "user_id", as: String.self)
                email = try row.decode(column: "email", as: String.self)
                createdAt = try row.decode(column: "created_at", as: Date.self)
                updatedAt = try row.decode(column: "updated_at", as: Date.self)
            }

            var output: Credential.Detail.Output {
                .init(
                    id: id,
                    userId: userId,
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

        public func find(id: String) async throws -> Credential.Detail.Output {
            let rows = try await context.connection.run(
                query: #"""
                    SELECT credential.id, email.identity_id AS user_id,
                        email.email, credential.created_at, credential.updated_at
                    FROM auth_email_credential AS credential
                    INNER JOIN auth_email AS email
                        ON email.id = credential.auth_email_id
                    WHERE credential.id = \#(id)
                    LIMIT 1;
                    """#
            ) { rows in
                try await rows.collect()
            }
            guard let row = rows.first else { throw RepositoryError.notFound }
            return try Row(from: row).output
        }
    }
}
