import FeatherDatabase
import Infrastructure
import struct Foundation.Date

extension RoleTable.Row {

    init(
        from row: DatabaseRow
    ) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.name = try row.decode(column: "name", as: String.self)
        self.notes = try row.decode(column: "notes", as: String.self)
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

struct RoleTable {

    struct Row {
        let id: String
        let name: String
        let notes: String
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func save(
        row: Row
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO user_role (
                    id,
                    name,
                    notes,
                    created_at,
                    updated_at
                )
                VALUES (
                    \#(row.id),
                    \#(row.name),
                    \#(row.notes),
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
                FROM user_role
                WHERE (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(name) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(notes) LIKE '%' || LOWER(\#(search ?? "")) || '%'
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
                FROM user_role
                WHERE (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(name) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(notes) LIKE '%' || LOWER(\#(search ?? "")) || '%'
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
                FROM user_role
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

    func update(
        id: String,
        row: Row
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                UPDATE user_role
                SET
                    id=\#(row.id),
                    name=\#(row.name),
                    notes=\#(row.notes),
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
                DELETE FROM user_role WHERE id=\#(id) RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect().first != nil
        }
    }
}
