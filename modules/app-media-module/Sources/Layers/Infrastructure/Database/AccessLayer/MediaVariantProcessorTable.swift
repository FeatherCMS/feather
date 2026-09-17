import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

extension MediaVariantProcessorTable.Row {
    init(from row: DatabaseRow) throws {
        id = try row.decode(column: "id", as: String.self)
        variantId = try row.decode(column: "variant_id", as: String.self)
        name = try row.decode(column: "name", as: String.self)
        matchExtensions = try row.decode(column: "match_extensions", as: String.self)
        commandTemplate = try row.decode(column: "command_template", as: String.self)
        isActive = try row.decode(column: "is_active", as: Bool.self)
        createdAt = try row.decode(column: "created_at", as: Date.self)
        updatedAt = try row.decode(column: "updated_at", as: Date.self)
    }
}

struct MediaVariantProcessorTable {
    struct Row {
        let id: String
        let variantId: String
        let name: String
        let matchExtensions: String
        let commandTemplate: String
        let isActive: Bool
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func create(row: Row) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO media_variant_processor (
                    id, variant_id, name, match_extensions, command_template,
                    is_active, created_at, updated_at
                ) VALUES (
                    \#(row.id), \#(row.variantId), \#(row.name), \#(row.matchExtensions),
                    \#(row.commandTemplate), \#(row.isActive), NOW(), NOW()
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
            query: #"SELECT * FROM media_variant_processor WHERE id = \#(id) LIMIT 1;"#
        ) { sequence in
            guard let row = try await sequence.collect().first else { return nil }
            return try Row(from: row)
        }
    }

    func list(variantId: String) async throws -> [Row] {
        try await connection.run(
            query: #"SELECT * FROM media_variant_processor WHERE variant_id = \#(variantId) ORDER BY name ASC;"#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func listActive() async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT p.* FROM media_variant_processor p
                JOIN media_variant v ON v.id = p.variant_id
                WHERE p.is_active = TRUE AND v.is_active = TRUE
                ORDER BY p.name ASC;
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func update(row: Row) async throws -> Row {
        try await connection.run(
            query: #"""
                UPDATE media_variant_processor
                SET name = \#(row.name), match_extensions = \#(row.matchExtensions),
                    command_template = \#(row.commandTemplate), is_active = \#(row.isActive),
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
            query: #"DELETE FROM media_variant_processor WHERE id IN (\#(unescaped: values)) RETURNING id;"#
        ) { sequence in
            try await sequence.collect().map { try $0.decode(column: "id", as: String.self) }
        }
    }
}
