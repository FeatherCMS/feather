import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

extension CredentialTable.Row {

    fileprivate init(
        from row: DatabaseRow
    ) throws {
        self.init(
            id: try row.decode(column: "id", as: String.self),
            userId: try row.decode(
                column: "user_id",
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
        public let userId: String
        public let email: String
        public let passwordHash: String
        public let createdAt: Date
        public let updatedAt: Date

        public init(
            id: String,
            userId: String,
            email: String,
            passwordHash: String,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.userId = userId
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

    public func list(
        userId: String? = nil,
        search: String?,
        orderBy: String,
        limit: Int,
        offset: Int
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT *
                FROM auth_credentials
                WHERE (
                    \#(userId == nil)
                    OR user_id=\#(userId ?? "")
                )
                AND (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(user_id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(email) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                )
                ORDER BY \#(unescaped: orderBy)
                LIMIT \#(limit)
                OFFSET \#(offset);
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    public func count(
        userId: String? = nil,
        search: String?
    ) async throws -> Int {
        try await connection.run(
            query: #"""
                SELECT COUNT(*) AS count
                FROM auth_credentials
                WHERE (
                    \#(userId == nil)
                    OR user_id=\#(userId ?? "")
                )
                AND (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(user_id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(email) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                );
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return 0
            }
            return try row.decode(column: "count", as: Int.self)
        }
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
        userId: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM auth_credentials
                WHERE user_id=\#(userId)
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
                    user_id,
                    email,
                    password_hash,
                    created_at,
                    updated_at
                )
                VALUES (
                    \#(row.id),
                    \#(row.userId),
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
                    user_id=\#(row.userId),
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
        ids: [String]
    ) async throws -> [String] {
        guard !ids.isEmpty else { return [] }
        let values =
            ids.map {
                "'\($0.replacingOccurrences(of: "'", with: "''"))'"
            }
            .joined(separator: ", ")
        return try await connection.run(
            query: #"""
                DELETE FROM auth_credentials
                WHERE id IN (\#(unescaped: values))
                RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect()
                .map {
                    try $0.decode(column: "id", as: String.self)
                }
        }
    }
}
