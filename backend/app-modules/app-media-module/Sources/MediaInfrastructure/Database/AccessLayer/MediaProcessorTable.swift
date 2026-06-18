import FeatherDatabase
import Infrastructure
import struct Foundation.Date

extension MediaProcessorTable.Row {
    init(from row: DatabaseRow) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.name = try row.decode(column: "name", as: String.self)
        self.matchExtensions = try row.decode(
            column: "match_extensions",
            as: String.self
        )
        self.commandTemplate = try row.decode(
            column: "command_template",
            as: String.self
        )
        self.isRequired = try row.decode(column: "is_required", as: Bool.self)
        self.isActive = try row.decode(column: "is_active", as: Bool.self)
        self.createdAt = try row.decode(column: "created_at", as: Date.self)
        self.updatedAt = try row.decode(column: "updated_at", as: Date.self)
    }
}

struct MediaProcessorTable {
    struct Row {
        let id: String
        let name: String
        let matchExtensions: String
        let commandTemplate: String
        let isRequired: Bool
        let isActive: Bool
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func create(
        row: Row
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO media_processor (
                    id, name, match_extensions, command_template, is_required, is_active, created_at, updated_at
                ) VALUES (
                    \#(row.id), \#(row.name), \#(row.matchExtensions), \#(row.commandTemplate), \#(row.isRequired), \#(row.isActive), NOW(), NOW()
                )
                RETURNING *;
                """#
        ) { seq in
            guard let row = try await seq.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: row)
        }
    }

    func find(
        id: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM media_processor
                WHERE id = \#(id)
                LIMIT 1;
                """#
        ) { seq in
            guard let row = try await seq.collect().first else { return nil }
            return try Row(from: row)
        }
    }

    func update(
        row: Row
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                UPDATE media_processor
                SET
                    name = \#(row.name),
                    match_extensions = \#(row.matchExtensions),
                    command_template = \#(row.commandTemplate),
                    is_required = \#(row.isRequired),
                    is_active = \#(row.isActive),
                    updated_at = NOW()
                WHERE id = \#(row.id)
                RETURNING *;
                """#
        ) { seq in
            guard let row = try await seq.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: row)
        }
    }

    func list() async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT *
                FROM media_processor
                ORDER BY name ASC;
                """#
        ) { seq in
            try await seq.collect().map { try Row(from: $0) }
        }
    }

    func listActive() async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT *
                FROM media_processor
                WHERE is_active = TRUE
                ORDER BY name ASC;
                """#
        ) { seq in
            try await seq.collect().map { try Row(from: $0) }
        }
    }

    func delete(
        id: String
    ) async throws -> Bool {
        try await connection.run(
            query: #"""
                DELETE FROM media_processor
                WHERE id = \#(id)
                RETURNING id;
                """#
        ) { seq in
            try await seq.collect().first != nil
        }
    }
}
