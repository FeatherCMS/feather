import FeatherDatabase
import Infrastructure
import struct Foundation.Date

extension RuleTable.Row {

    init(from row: DatabaseRow) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.source = try row.decode(column: "source", as: String.self)
        self.destination = try row.decode(
            column: "destination",
            as: String.self
        )
        self.statusCode = try row.decode(column: "status_code", as: Int.self)
        self.notes = try row.decode(column: "notes", as: String.self)
        self.createdAt = try row.decode(column: "created_at", as: Date.self)
        self.updatedAt = try row.decode(column: "updated_at", as: Date.self)
    }
}

struct RuleTable {

    struct Row {

        struct Create {
            let id: String
            let source: String
            let destination: String
            let statusCode: Int
            let notes: String
        }

        let id: String
        let source: String
        let destination: String
        let statusCode: Int
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
                INSERT INTO redirect_rule (
                    id,
                    source,
                    destination,
                    status_code,
                    notes,
                    created_at,
                    updated_at
                )
                VALUES (
                    \#(row.id),
                    \#(row.source),
                    \#(row.destination),
                    \#(row.statusCode),
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
        statusCode: Int?,
        orderBy: String,
        limit: Int,
        offset: Int
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT *
                FROM redirect_rule
                WHERE (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(source) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(destination) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR CAST(status_code AS TEXT) LIKE '%' || \#(search ?? "") || '%'
                    OR LOWER(notes) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                )
                AND (
                    \#(statusCode == nil)
                    OR status_code = \#(statusCode ?? 0)
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
        search: String?,
        statusCode: Int?
    ) async throws -> Int {
        try await connection.run(
            query: #"""
                SELECT COUNT(*) AS count
                FROM redirect_rule
                WHERE (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(source) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(destination) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR CAST(status_code AS TEXT) LIKE '%' || \#(search ?? "") || '%'
                    OR LOWER(notes) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                )
                AND (
                    \#(statusCode == nil)
                    OR status_code = \#(statusCode ?? 0)
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
                FROM redirect_rule
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
        source: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM redirect_rule
                WHERE source=\#(source)
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
                UPDATE redirect_rule
                SET
                    source=\#(row.source),
                    destination=\#(row.destination),
                    status_code=\#(row.statusCode),
                    notes=\#(row.notes),
                    updated_at=NOW()
                WHERE id=\#(id)
                RETURNING *;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: row)
        }
    }

    func delete(
        id: String
    ) async throws -> Bool {
        try await connection.run(
            query: #"""
                DELETE FROM redirect_rule WHERE id=\#(id) RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect().first != nil
        }
    }
}
