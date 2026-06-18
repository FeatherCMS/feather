import FeatherDatabase
import Infrastructure
import struct Foundation.Date

extension MediaAssetTable.Row {
    init(from row: DatabaseRow) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.folderId = try row.decode(column: "folder_id", as: String?.self)
        self.storageKey = try row.decode(column: "storage_key", as: String.self)
        self.baseName = try row.decode(column: "base_name", as: String.self)
        self.type = try row.decode(column: "type", as: String.self)
        self.sizeBytes = try row.decode(column: "size_bytes", as: Int64.self)
        self.status = try row.decode(column: "status", as: String.self)
        self.title = try row.decode(column: "title", as: String?.self)
        self.altText = try row.decode(column: "alt_text", as: String?.self)
        self.createdAt = try row.decode(column: "created_at", as: Date.self)
        self.updatedAt = try row.decode(column: "updated_at", as: Date.self)
        self.deletedAt = try row.decode(column: "deleted_at", as: Date?.self)
    }
}

struct MediaAssetTable {
    struct Row {
        struct Create {
            let id: String
            let folderId: String?
            let storageKey: String
            let baseName: String
            let type: String
            let sizeBytes: Int64
            let status: String
            let title: String?
            let altText: String?
        }

        let id: String
        let folderId: String?
        let storageKey: String
        let baseName: String
        let type: String
        let sizeBytes: Int64
        let status: String
        let title: String?
        let altText: String?
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
                INSERT INTO media_asset (
                    id, folder_id, storage_key, base_name, type, size_bytes, status, title, alt_text, created_at, updated_at
                ) VALUES (
                    \#(row.id), \#(row.folderId), \#(row.storageKey), \#(row.baseName), \#(row.type), \#(Int(row.sizeBytes)), \#(row.status), \#(row.title), \#(row.altText), NOW(), NOW()
                ) RETURNING *;
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
                SELECT * FROM media_asset
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
        storageKey: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT * FROM media_asset
                WHERE storage_key = \#(storageKey)
                  AND deleted_at IS NULL
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
                UPDATE media_asset
                SET folder_id = \#(row.folderId),
                    storage_key = \#(row.storageKey),
                    base_name = \#(row.baseName),
                    type = \#(row.type),
                    size_bytes = \#(Int(row.sizeBytes)),
                    status = \#(row.status),
                    title = \#(row.title),
                    alt_text = \#(row.altText),
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

    func hardDelete(
        id: String
    ) async throws -> Bool {
        try await connection.run(
            query: #"""
                DELETE FROM media_asset
                WHERE id = \#(id)
                RETURNING id;
                """#
        ) { seq in
            try await seq.collect().first != nil
        }
    }

    func list(
        parentId: String?,
        search: String?,
        orderBy: String,
        limit: Int,
        offset: Int
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT *
                FROM media_asset
                WHERE deleted_at IS NULL
                  AND (
                    (\#(parentId == nil) AND folder_id IS NULL)
                    OR folder_id = \#(parentId)
                  )
                  AND (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(storage_key) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(base_name) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(type) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(status) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(COALESCE(title, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(COALESCE(alt_text, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                  )
                ORDER BY \#(unescaped: orderBy)
                LIMIT \#(limit)
                OFFSET \#(offset);
                """#
        ) { seq in
            try await seq.collect().map { try Row(from: $0) }
        }
    }

    func count(
        parentId: String?,
        search: String?
    ) async throws -> Int {
        try await connection.run(
            query: #"""
                SELECT COUNT(*) AS count
                FROM media_asset
                WHERE deleted_at IS NULL
                  AND (
                    (\#(parentId == nil) AND folder_id IS NULL)
                    OR folder_id = \#(parentId)
                  )
                  AND (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(storage_key) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(base_name) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(type) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(status) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(COALESCE(title, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(COALESCE(alt_text, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                  );
                """#
        ) { seq in
            guard let row = try await seq.collect().first else { return 0 }
            return try row.decode(column: "count", as: Int.self)
        }
    }

    func list(
        folderIds: [String]
    ) async throws -> [Row] {
        guard !folderIds.isEmpty else { return [] }
        let values =
            folderIds.map {
                "'\($0.replacingOccurrences(of: "'", with: "''"))'"
            }
            .joined(separator: ", ")
        return try await connection.run(
            query: #"""
                SELECT *
                FROM media_asset
                WHERE deleted_at IS NULL
                  AND folder_id IN (\#(unescaped: values))
                ORDER BY created_at ASC, id ASC;
                """#
        ) { seq in
            try await seq.collect().map { try Row(from: $0) }
        }
    }
}
