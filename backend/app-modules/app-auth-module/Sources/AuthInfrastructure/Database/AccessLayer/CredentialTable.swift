import FeatherDatabase
import Infrastructure
import struct Foundation.Date

private extension CredentialTable.Row {

    init(
        from row: DatabaseRow
    ) throws {
        self.init(
            id: try row.decode(column: "id", as: String.self),
            accountID: try row.decode(
                column: "account_id",
                as: String.self
            ),
            email: try row.decode(column: "email", as: String.self),
            passwordHash: try row.decode(
                column: "password_hash",
                as: String.self
            ),
            createdAt: try row.decode(
                column: "created_at",
                as: Date.self
            ),
            updatedAt: try row.decode(
                column: "updated_at",
                as: Date.self
            )
        )
    }
}

public struct CredentialTable {

    public struct Row: Sendable {

        public let id: String
        public let accountID: String
        public let email: String
        public let passwordHash: String
        public let createdAt: Date
        public let updatedAt: Date

        public init(
            id: String,
            accountID: String,
            email: String,
            passwordHash: String,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.accountID = accountID
            self.email = email
            self.passwordHash = passwordHash
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }

    public let connection: any DatabaseConnection

    public init(
        connection: any DatabaseConnection
    ) {
        self.connection = connection
    }

    public func find(
        id: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM auth_credentials
                WHERE id=\#(id)
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    public func findBy(
        accountID: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM auth_credentials
                WHERE account_id=\#(accountID)
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    public func findBy(
        email: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM auth_credentials
                WHERE email=\#(email)
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    public func save(
        row: Row
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO auth_credentials (
                    id,
                    account_id,
                    email,
                    password_hash,
                    created_at,
                    updated_at
                )
                VALUES (
                    \#(row.id),
                    \#(row.accountID),
                    \#(row.email),
                    \#(row.passwordHash),
                    NOW(),
                    NOW()
                )
                RETURNING *;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: row)
        }
    }

    public func update(
        id: String,
        row: Row
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                UPDATE auth_credentials
                SET
                    id=\#(row.id),
                    account_id=\#(row.accountID),
                    email=\#(row.email),
                    password_hash=\#(row.passwordHash),
                    updated_at=NOW()
                WHERE id=\#(id)
                RETURNING *;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        try await connection.run(
            query: #"""
                DELETE FROM auth_credentials
                WHERE id=\#(id)
                RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect().first != nil
        }
    }
}
