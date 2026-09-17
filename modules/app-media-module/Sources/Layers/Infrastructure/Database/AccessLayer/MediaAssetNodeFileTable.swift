import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

extension MediaAssetNodeFileTable.Row {
    init(from row: DatabaseRow) throws {
        id = try row.decode(column: "id", as: String.self)
        folderId = try row.decode(column: "folder_id", as: String?.self)
        name = try row.decode(column: "name", as: String.self)
        slug = try row.decode(column: "slug", as: String.self)
        slugPath = try row.decode(column: "slug_path", as: String.self)
        storageObjectId = try row.decode(
            column: "storage_object_id",
            as: String.self
        )
        objectKey = try row.decode(column: "object_key", as: String.self)
        `extension` = try row.decode(column: "extension", as: String.self)
        contentType = try row.decode(column: "content_type", as: String.self)
        sizeBytes = try row.decode(column: "size_bytes", as: Int64.self)
        status = try row.decode(column: "status", as: String.self)
        title = try row.decode(column: "title", as: String?.self)
        altText = try row.decode(column: "alt_text", as: String?.self)
        createdAt = try row.decode(column: "created_at", as: Date.self)
        updatedAt = try row.decode(column: "updated_at", as: Date.self)
        deletedAt = try row.decode(column: "deleted_at", as: Date?.self)
    }
}

struct MediaAssetNodeFileTable {
    struct Row {
        struct Create {
            let id: String
            let folderId: String?
            let name: String
            let slug: String
            let slugPath: String
            let storageObjectId: String
            let `extension`: String
            let contentType: String
            let sizeBytes: Int64
            let status: String
            let title: String?
            let altText: String?
        }

        let id: String
        let folderId: String?
        let name: String
        let slug: String
        let slugPath: String
        let storageObjectId: String
        let objectKey: String
        let `extension`: String
        let contentType: String
        let sizeBytes: Int64
        let status: String
        let title: String?
        let altText: String?
        let createdAt: Date
        let updatedAt: Date
        let deletedAt: Date?
    }

    let connection: any DatabaseConnection

    func create(row: Row.Create) async throws -> Row {
        _ = try await MediaAssetNodeTable(connection: connection)
            .create(
                row: .init(
                    id: row.id,
                    parentId: row.folderId,
                    name: row.name,
                    slug: row.slug,
                    slugPath: row.slugPath
                )
            )
        _ = try await connection.run(
            query: #"""
                INSERT INTO media_asset_node_file (
                    node_id, storage_object_id, extension, content_type,
                    size_bytes, status, title, alt_text
                ) VALUES (
                    \#(row.id), \#(row.storageObjectId), \#(row.extension), \#(row.contentType),
                    \#(Int(row.sizeBytes)), \#(row.status), \#(row.title), \#(row.altText)
                );
                """#
        ) { _ in }
        guard let result = try await find(id: row.id) else {
            throw RepositoryError.notFound
        }
        return result
    }

    func find(id: String) async throws -> Row? {
        try await connection.run(
            query: #"""
                \#(unescaped: mediaAssetNodeFileSelectPrefix)
                WHERE n.id = \#(id) AND n.deleted_at IS NULL
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    func resolve(ids: [String]) async throws -> [Row] {
        guard !ids.isEmpty else { return [] }
        let values = mediaAssetNodeFileSQLValues(ids)
        return try await connection.run(
            query: #"""
                \#(unescaped: mediaAssetNodeFileSelectPrefix)
                WHERE n.id IN (\#(unescaped: values)) AND n.deleted_at IS NULL;
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func update(row: Row) async throws -> Row {
        _ = try await MediaAssetNodeTable(connection: connection)
            .update(
                row: .init(
                    id: row.id,
                    parentId: row.folderId,
                    name: row.name,
                    slug: row.slug,
                    slugPath: row.slugPath
                )
            )
        _ = try await connection.run(
            query: #"""
                UPDATE media_asset_node_file
                SET status = \#(row.status), title = \#(row.title), alt_text = \#(row.altText)
                WHERE node_id = \#(row.id);
                """#
        ) { _ in }
        guard let result = try await find(id: row.id) else {
            throw RepositoryError.notFound
        }
        return result
    }

    func updateStatus(id: String, status: String) async throws {
        try await connection.run(
            query: #"UPDATE media_asset_node_file SET status = \#(status) WHERE node_id = \#(id);"#
        ) { _ in }
    }

    func delete(ids: [String]) async throws -> [String] {
        guard !ids.isEmpty else { return [] }
        let values = mediaAssetNodeFileSQLValues(ids)
        return try await connection.run(
            query: #"""
                DELETE FROM media_asset_node
                WHERE id IN (\#(unescaped: values))
                  AND EXISTS (SELECT 1 FROM media_asset_node_file f WHERE f.node_id = media_asset_node.id)
                RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect()
                .map {
                    try $0.decode(column: "id", as: String.self)
                }
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
                \#(unescaped: mediaAssetNodeFileSelectPrefix)
                WHERE n.deleted_at IS NULL
                  AND ((\#(parentId == nil) AND n.parent_id IS NULL) OR n.parent_id = \#(parentId))
                  AND (
                    \#(search == nil)
                    OR LOWER(n.id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(n.name) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(n.slug) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(n.slug_path) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(f.extension) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(f.status) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(COALESCE(f.title, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(COALESCE(f.alt_text, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                  )
                ORDER BY \#(unescaped: orderBy)
                LIMIT \#(limit)
                OFFSET \#(offset);
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func count(parentId: String?, search: String?) async throws -> Int {
        try await connection.run(
            query: #"""
                SELECT COUNT(*) AS count
                FROM media_asset_node n
                JOIN media_asset_node_file f ON f.node_id = n.id
                WHERE n.deleted_at IS NULL
                  AND ((\#(parentId == nil) AND n.parent_id IS NULL) OR n.parent_id = \#(parentId))
                  AND (
                    \#(search == nil)
                    OR LOWER(n.id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(n.name) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(n.slug_path) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                  );
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else { return 0 }
            return try row.decode(column: "count", as: Int.self)
        }
    }

    func list(folderIds: [String]) async throws -> [Row] {
        guard !folderIds.isEmpty else { return [] }
        let values = mediaAssetNodeFileSQLValues(folderIds)
        return try await connection.run(
            query: #"""
                \#(unescaped: mediaAssetNodeFileSelectPrefix)
                WHERE n.deleted_at IS NULL AND n.parent_id IN (\#(unescaped: values))
                ORDER BY n.created_at ASC, n.id ASC;
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }
}

private let mediaAssetNodeFileSelectPrefix = #"""
    SELECT
        n.id,
        n.parent_id AS folder_id,
        n.name,
        n.slug,
        n.slug_path,
        f.storage_object_id,
        o.object_key,
        f.extension,
        f.content_type,
        f.size_bytes,
        f.status,
        f.title,
        f.alt_text,
        n.created_at,
        n.updated_at,
        n.deleted_at
    FROM media_asset_node n
    JOIN media_asset_node_file f ON f.node_id = n.id
    JOIN media_asset_storage_object o ON o.id = f.storage_object_id
    """#

private func mediaAssetNodeFileSQLValues(_ values: [String]) -> String {
    values.map { value in
        let escaped = value.replacingOccurrences(of: "'", with: "''")
        return "'\(escaped)'"
    }
    .joined(separator: ", ")
}
