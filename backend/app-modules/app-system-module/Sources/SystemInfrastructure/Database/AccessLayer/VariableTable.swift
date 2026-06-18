import FeatherDatabase
import Infrastructure
import struct Foundation.Date

extension VariableTable.Row {

    init(from row: DatabaseRow) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.name = try row.decode(column: "name", as: String.self)
        self.value = try row.decode(column: "value", as: String.self)
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

struct VariableTable {

    struct Row {

        struct Create {
            let id: String
            let name: String
            let value: String
            let notes: String
        }

        let id: String
        let name: String
        let value: String
        let notes: String
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func create(
        row: Row.Create
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO system_variable (
                    id,
                    name,
                    value,
                    notes,
                    created_at,
                    updated_at
                )
                VALUES (
                    \#(row.id),
                    \#(row.name),
                    \#(row.value),
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
                FROM system_variable
                WHERE (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(name) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(value) LIKE '%' || LOWER(\#(search ?? "")) || '%'
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
                FROM system_variable
                WHERE (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(name) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(value) LIKE '%' || LOWER(\#(search ?? "")) || '%'
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
                FROM system_variable
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
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                UPDATE system_variable
                SET
                    id=\#(row.id),
                    name=\#(row.name),
                    value=\#(row.value),
                    notes=\#(row.notes),
                    updated_at=NOW()
                WHERE id=\#(id)
                RETURNING *;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                fatalError("TODO")
            }
            return try Row(from: row)
        }
    }

    func delete(
        id: String
    ) async throws -> Bool {
        try await connection.run(
            query: #"""
                DELETE FROM system_variable WHERE id=\#(id) RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect().first != nil
        }
    }
}
