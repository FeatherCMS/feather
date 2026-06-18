import FeatherDatabase
import Infrastructure
import struct Foundation.Date

extension SessionTable.Row {

    init(
        from row: DatabaseRow
    ) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.token = try row.decode(column: "token", as: String.self)
        self.accountId = try row.decode(
            column: "account_id",
            as: String.self
        )
        self.isPersistent = try row.decode(
            column: "is_persistent",
            as: Bool.self
        )
        self.createdAt = try row.decode(
            column: "created_at",
            as: Date.self
        )
        self.updatedAt = try row.decode(
            column: "updated_at",
            as: Date.self
        )
        self.expiresAt = try row.decode(
            column: "expires_at",
            as: Date.self
        )
    }
}

struct SessionTable {

    struct Row {
        struct Create {
            let id: String
            let token: String
            let accountId: String
            let isPersistent: Bool
            let expiresAtInterval: Double
        }

        let id: String
        let token: String
        let accountId: String
        let isPersistent: Bool
        let createdAt: Date
        let updatedAt: Date
        let expiresAt: Date

    }

    let connection: any DatabaseConnection

    func save(
        row: Row.Create
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO user_session (
                    id,
                    token,
                    account_id,
                    is_persistent,
                    created_at,
                    updated_at,
                    expires_at
                )
                VALUES (
                    \#(row.id),
                    \#(row.token),
                    \#(row.accountId),
                    \#(row.isPersistent),
                    NOW(),
                    NOW(),
                    NOW() + (\#(row.expiresAtInterval) * INTERVAL '1 second')
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

    func list() async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT * FROM user_session ORDER BY id ASC;
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func find(
        id: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM user_session
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
                FROM user_session
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

    func update(
        id: String,
        row: Row
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                UPDATE user_session
                SET
                    id=\#(row.id),
                    token=\#(row.token),
                    account_id=\#(row.accountId),
                    is_persistent=\#(row.isPersistent),
                    updated_at=NOW(),
                    expires_at=TO_TIMESTAMP(\#(row.expiresAt.timeIntervalSince1970))
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
                DELETE FROM user_session WHERE id=\#(id) RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect().first != nil
        }
    }
}
