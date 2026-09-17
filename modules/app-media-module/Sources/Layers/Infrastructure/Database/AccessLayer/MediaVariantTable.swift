import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

extension MediaVariantTable.Row {
    init(from row: DatabaseRow) throws {
        id = try row.decode(column: "id", as: String.self)
        key = try row.decode(column: "variant_key", as: String.self)
        name = try row.decode(column: "name", as: String.self)
        isRequired = try row.decode(column: "is_required", as: Bool.self)
        isActive = try row.decode(column: "is_active", as: Bool.self)
        createdAt = try row.decode(column: "created_at", as: Date.self)
        updatedAt = try row.decode(column: "updated_at", as: Date.self)
    }
}

struct MediaVariantTable {
    struct Row {
        let id: String
        let key: String
        let name: String
        let isRequired: Bool
        let isActive: Bool
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func create(row: Row) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO media_variant (
                    id, variant_key, name, is_required, is_active, created_at, updated_at
                ) VALUES (
                    \#(row.id), \#(row.key), \#(row.name), \#(row.isRequired), \#(row.isActive), NOW(), NOW()
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

    func find(id: String) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT * FROM media_variant WHERE id = \#(id) LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else { return nil }
            return try Row(from: row)
        }
    }

    func list() async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT * FROM media_variant ORDER BY name ASC;
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func listActive() async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT * FROM media_variant WHERE is_active = TRUE ORDER BY name ASC;
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func update(row: Row) async throws -> Row {
        try await connection.run(
            query: #"""
                UPDATE media_variant
                SET variant_key = \#(row.key), name = \#(row.name),
                    is_required = \#(row.isRequired), is_active = \#(row.isActive),
                    updated_at = NOW()
                WHERE id = \#(row.id)
                RETURNING *;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: row)
        }
    }

    func delete(ids: [String]) async throws -> [String] {
        guard !ids.isEmpty else { return [] }
        let values = ids.map { "'\($0.replacingOccurrences(of: "'", with: "''"))'" }.joined(separator: ", ")
        return try await connection.run(
            query: #"DELETE FROM media_variant WHERE id IN (\#(unescaped: values)) RETURNING id;"#
        ) { sequence in
            try await sequence.collect().map { try $0.decode(column: "id", as: String.self) }
        }
    }
}
