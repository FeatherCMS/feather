import FeatherDatabase
import Infrastructure
import struct Foundation.Date

extension MediaFolderTable.Row {
    init(from row: DatabaseRow) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.parentId = try row.decode(column: "parent_id", as: String?.self)
        self.name = try row.decode(column: "name", as: String.self)
        self.path = try row.decode(column: "path", as: String.self)
        self.assetCount = try row.decode(column: "asset_count", as: Int.self)
        self.totalSizeBytes = try row.decode(
            column: "total_size_bytes",
            as: Int64.self
        )
        self.createdAt = try row.decode(column: "created_at", as: Date.self)
        self.updatedAt = try row.decode(column: "updated_at", as: Date.self)
        self.deletedAt = try row.decode(column: "deleted_at", as: Date?.self)
    }
}

struct MediaFolderTable {
    struct Row {
        struct Create {
            let id: String
            let parentId: String?
            let name: String
            let path: String
            let assetCount: Int
            let totalSizeBytes: Int64
        }

        let id: String
        let parentId: String?
        let name: String
        let path: String
        let assetCount: Int
        let totalSizeBytes: Int64
        let createdAt: Date
        let updatedAt: Date
        let deletedAt: Date?
    }

    let connection: any DatabaseConnection

    func create(
        row: Row.Create
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO media_folder (
                    id, parent_id, name, path, asset_count, total_size_bytes, created_at, updated_at
                ) VALUES (
                    \#(row.id), \#(row.parentId), \#(row.name), \#(row.path), \#(row.assetCount), \#(Int(row.totalSizeBytes)), NOW(), NOW()
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

    func update(
        row: Row
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                UPDATE media_folder
                SET parent_id = \#(row.parentId),
                    name = \#(row.name),
                    path = \#(row.path),
                    asset_count = \#(row.assetCount),
                    total_size_bytes = \#(Int(row.totalSizeBytes)),
                    updated_at = NOW()
                WHERE id = \#(row.id)
                  AND deleted_at IS NULL
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
                FROM media_folder
                WHERE id = \#(id)
                  AND deleted_at IS NULL
                LIMIT 1;
                """#
        ) { seq in
            guard let row = try await seq.collect().first else { return nil }
            return try Row(from: row)
        }
    }

    func find(
        path: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM media_folder
                WHERE path = \#(path)
                  AND deleted_at IS NULL
                LIMIT 1;
                """#
        ) { seq in
            guard let row = try await seq.collect().first else { return nil }
            return try Row(from: row)
        }
    }

    func list(
        parentId: String?
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT *
                FROM media_folder
                WHERE deleted_at IS NULL
                  AND (
                    (\#(parentId == nil) AND parent_id IS NULL)
                    OR parent_id = \#(parentId)
                  )
                ORDER BY LOWER(name) ASC, id ASC;
                """#
        ) { seq in
            try await seq.collect().map { try Row(from: $0) }
        }
    }

    func listDescendants(
        path: String
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT *
                FROM media_folder
                WHERE deleted_at IS NULL
                  AND (
                    path = \#(path)
                    OR path LIKE \#(path + "/%")
                  )
                ORDER BY LENGTH(path) ASC, LOWER(name) ASC, id ASC;
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
                DELETE FROM media_folder
                WHERE id = \#(id)
                RETURNING id;
                """#
        ) { seq in
            try await seq.collect().first != nil
        }
    }
}
