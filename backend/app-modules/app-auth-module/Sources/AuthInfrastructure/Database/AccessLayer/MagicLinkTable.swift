import FeatherDatabase
import Infrastructure
import struct Foundation.Date

extension MagicLinkTable.Row {

    init(
        from row: DatabaseRow
    ) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.email = try row.decode(column: "email", as: String.self)
        self.token = try row.decode(column: "token", as: String.self)
        self.expiresAt = try row.decode(
            column: "expires_at",
            as: Date.self
        )
        self.isPersistent = try row.decode(
            column: "is_persistent",
            as: Bool.self
        )
        self.isUsed = try row.decode(column: "is_used", as: Bool.self)
        self.createdAt = try row.decode(
            column: "created_at",
            as: Date.self
        )
        self.updatedAt = try row.decode(
            column: "updated_at",
            as: Date.self
        )
    }
}

struct MagicLinkTable {

    struct Row {
        struct Create {
            let id: String
            let email: String
            let token: String
            let expiresAtInterval: Double
            let isPersistent: Bool
            let isUsed: Bool
        }

        let id: String
        let email: String
        let token: String
        let expiresAt: Date
        let isPersistent: Bool
        let isUsed: Bool
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func save(
        row: Row.Create
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO user_magic_link (
                    id,
                    email,
                    token,
                    expires_at,
                    is_persistent,
                    is_used,
                    created_at,
                    updated_at
                )
                VALUES (
                    \#(row.id),
                    \#(row.email),
                    \#(row.token),
                    NOW() + (\#(row.expiresAtInterval) * INTERVAL '1 second'),
                    \#(row.isPersistent),
                    \#(row.isUsed),
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

    func list(
        search: String?,
        orderBy: String,
        limit: Int,
        offset: Int
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT *
                FROM user_magic_link
                WHERE (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(email) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(token) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR CAST(expires_at AS TEXT) LIKE '%' || \#(search ?? "") || '%'
                    OR LOWER(CAST(is_persistent AS TEXT)) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(CAST(is_used AS TEXT)) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                )
                ORDER BY \#(unescaped: orderBy)
                LIMIT \#(limit)
                OFFSET \#(offset);
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func count(
        search: String?
    ) async throws -> Int {
        try await connection.run(
            query: #"""
                SELECT COUNT(*) AS count
                FROM user_magic_link
                WHERE (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(email) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(token) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR CAST(expires_at AS TEXT) LIKE '%' || \#(search ?? "") || '%'
                    OR LOWER(CAST(is_persistent AS TEXT)) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(CAST(is_used AS TEXT)) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                );
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return 0
            }
            return try row.decode(column: "count", as: Int.self)
        }
    }

    func find(
        id: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM user_magic_link
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

    func find(
        token: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM user_magic_link
                WHERE token=\#(token)
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    func consume(
        token: String,
        now: Double
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                UPDATE user_magic_link
                SET
                    is_used=TRUE,
                    updated_at=NOW()
                WHERE
                    token=\#(token)
                    AND is_used=FALSE
                    AND expires_at>TO_TIMESTAMP(\#(now))
                RETURNING *;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    func update(
        id: String,
        row: Row
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                UPDATE user_magic_link
                SET
                    id=\#(row.id),
                    email=\#(row.email),
                    token=\#(row.token),
                    expires_at=TO_TIMESTAMP(\#(row.expiresAt.timeIntervalSince1970)),
                    is_persistent=\#(row.isPersistent),
                    is_used=\#(row.isUsed),
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

    func delete(
        id: String
    ) async throws -> Bool {
        try await connection.run(
            query: #"""
                DELETE FROM user_magic_link WHERE id=\#(id) RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect().first != nil
        }
    }
}
