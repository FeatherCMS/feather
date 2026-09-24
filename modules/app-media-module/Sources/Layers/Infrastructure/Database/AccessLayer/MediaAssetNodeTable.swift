import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

struct MediaAssetNodeTable {
    struct Row {
        struct Create {
            let id: String
            let parentId: String?
            let name: String
            let slug: String
            let slugPath: String
        }

        struct Update {
            let id: String
            let parentId: String?
            let name: String
            let slug: String
            let slugPath: String
        }

        let id: String
        let parentId: String?
        let name: String
        let slug: String
        let slugPath: String
        let createdAt: Date
        let updatedAt: Date
        let deletedAt: Date?

        init(from row: any DatabaseRow) throws {
            id = try row.decode(column: "id", as: String.self)
            parentId = try row.decode(column: "parent_id", as: String?.self)
            name = try row.decode(column: "name", as: String.self)
            slug = try row.decode(column: "slug", as: String.self)
            slugPath = try row.decode(column: "slug_path", as: String.self)
            createdAt = try row.decode(column: "created_at", as: Date.self)
            updatedAt = try row.decode(column: "updated_at", as: Date.self)
            deletedAt = try row.decode(column: "deleted_at", as: Date?.self)
        }
    }

    struct SearchRow {
        let kind: String
        let id: String
        let parentId: String?
        let name: String
        let slug: String
        let slugPath: String
        let objectKey: String?
        let `extension`: String?
        let contentType: String?
        let sizeBytes: Int64?
        let status: String?
        let title: String?
        let altText: String?
        let assetCount: Int?
        let totalSizeBytes: Int64?
        let createdAt: Date
        let updatedAt: Date

        init(from row: any DatabaseRow) throws {
            kind = try row.decode(column: "kind", as: String.self)
            id = try row.decode(column: "id", as: String.self)
            parentId = try row.decode(column: "parent_id", as: String?.self)
            name = try row.decode(column: "name", as: String.self)
            slug = try row.decode(column: "slug", as: String.self)
            slugPath = try row.decode(column: "slug_path", as: String.self)
            objectKey = try row.decode(column: "object_key", as: String?.self)
            `extension` = try row.decode(column: "extension", as: String?.self)
            contentType = try row.decode(
                column: "content_type",
                as: String?.self
            )
            sizeBytes = try row.decode(column: "size_bytes", as: Int64?.self)
            status = try row.decode(column: "status", as: String?.self)
            title = try row.decode(column: "title", as: String?.self)
            altText = try row.decode(column: "alt_text", as: String?.self)
            assetCount = try row.decode(column: "asset_count", as: Int?.self)
            totalSizeBytes = try row.decode(
                column: "total_size_bytes",
                as: Int64?.self
            )
            createdAt = try row.decode(column: "created_at", as: Date.self)
            updatedAt = try row.decode(column: "updated_at", as: Date.self)
        }
    }

    let connection: any DatabaseConnection

    func create(row: Row.Create) async throws -> Row {
        _ = try await connection.run(
            query: #"""
                INSERT INTO media_asset_node (
                    id, parent_id, name, slug, slug_path, created_at, updated_at
                ) VALUES (
                    \#(row.id), \#(row.parentId), \#(row.name), \#(row.slug), \#(row.slugPath), NOW(), NOW()
                );
                """#
        ) { _ in }
        guard let result = try await find(id: row.id) else {
            throw RepositoryError.notFound
        }
        return result
    }

    func update(row: Row.Update) async throws -> Row {
        guard let old = try await find(id: row.id) else {
            throw RepositoryError.notFound
        }
        _ = try await connection.run(
            query: #"""
                UPDATE media_asset_node
                SET parent_id = \#(row.parentId),
                    name = \#(row.name),
                    slug = \#(row.slug),
                    slug_path = \#(row.slugPath),
                    updated_at = NOW()
                WHERE id = \#(row.id) AND deleted_at IS NULL;
                """#
        ) { _ in }
        if old.slugPath != row.slugPath {
            _ = try await connection.run(
                query: #"""
                    UPDATE media_asset_node
                    SET slug_path = \#(row.slugPath) || SUBSTRING(slug_path FROM \#(old.slugPath.count + 1)),
                        updated_at = NOW()
                    WHERE slug_path LIKE \#(old.slugPath + "/%") AND deleted_at IS NULL;
                    """#
            ) { _ in }
        }
        guard let result = try await find(id: row.id) else {
            throw RepositoryError.notFound
        }
        return result
    }

    func find(id: String) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT id, parent_id, name, slug, slug_path,
                       created_at, updated_at, deleted_at
                FROM media_asset_node
                WHERE id = \#(id) AND deleted_at IS NULL
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    func find(slugPath: String) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT id, parent_id, name, slug, slug_path,
                       created_at, updated_at, deleted_at
                FROM media_asset_node
                WHERE slug_path = \#(slugPath) AND deleted_at IS NULL
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    func delete(ids: [String]) async throws -> [String] {
        guard !ids.isEmpty else { return [] }
        let values = mediaAssetNodeSQLValues(ids)
        return try await connection.run(
            query: #"""
                DELETE FROM media_asset_node
                WHERE id IN (\#(unescaped: values))
                RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect()
                .map { try $0.decode(column: "id", as: String.self) }
        }
    }

    func search(
        parentId: String?,
        search: String?,
        orderBy: String,
        limit: Int,
        offset: Int
    ) async throws -> [SearchRow] {
        try await connection.run(
            query: #"""
                WITH entries AS (
                    SELECT 'folder' AS kind, 0 AS kind_rank, n.id, n.parent_id, n.name, n.slug, n.slug_path,
                           NULL::text AS object_key, NULL::text AS extension, NULL::text AS content_type,
                           NULL::bigint AS size_bytes, NULL::text AS status, NULL::text AS title, NULL::text AS alt_text,
                           f.asset_count, f.total_size_bytes, n.created_at, n.updated_at
                    FROM media_asset_node n
                    JOIN media_asset_node_folder f ON f.node_id = n.id
                    WHERE n.deleted_at IS NULL
                      AND ((\#(parentId == nil) AND n.parent_id IS NULL) OR n.parent_id = \#(parentId))
                      AND (\#(search == nil) OR LOWER(n.name) LIKE '%' || LOWER(\#(search ?? "")) || '%' OR LOWER(n.slug_path) LIKE '%' || LOWER(\#(search ?? "")) || '%')
                    UNION ALL
                    SELECT 'file' AS kind, 1 AS kind_rank, n.id, n.parent_id, n.name, n.slug, n.slug_path,
                           o.object_key, f.extension, f.content_type, f.size_bytes, f.status, f.title, f.alt_text,
                           NULL::integer AS asset_count, NULL::bigint AS total_size_bytes, n.created_at, n.updated_at
                    FROM media_asset_node n
                    JOIN media_asset_node_file f ON f.node_id = n.id
                    JOIN media_asset_storage_object o ON o.id = f.storage_object_id
                    WHERE n.deleted_at IS NULL
                      AND ((\#(parentId == nil) AND n.parent_id IS NULL) OR n.parent_id = \#(parentId))
                      AND (\#(search == nil) OR LOWER(n.id) LIKE '%' || LOWER(\#(search ?? "")) || '%' OR LOWER(n.name) LIKE '%' || LOWER(\#(search ?? "")) || '%' OR LOWER(n.slug_path) LIKE '%' || LOWER(\#(search ?? "")) || '%' OR LOWER(f.extension) LIKE '%' || LOWER(\#(search ?? "")) || '%' OR LOWER(f.status) LIKE '%' || LOWER(\#(search ?? "")) || '%' OR LOWER(COALESCE(f.title, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%' OR LOWER(COALESCE(f.alt_text, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%')
                )
                SELECT * FROM entries
                ORDER BY \#(unescaped: orderBy)
                LIMIT \#(limit) OFFSET \#(offset);
                """#
        ) { sequence in
            try await sequence.collect().map { try SearchRow(from: $0) }
        }
    }

    func count(parentId: String?, search: String?) async throws -> Int {
        try await connection.run(
            query: #"""
                SELECT COUNT(*) AS count
                FROM media_asset_node n
                WHERE n.deleted_at IS NULL
                  AND ((\#(parentId == nil) AND n.parent_id IS NULL) OR n.parent_id = \#(parentId))
                  AND (\#(search == nil) OR LOWER(n.name) LIKE '%' || LOWER(\#(search ?? "")) || '%' OR LOWER(n.slug_path) LIKE '%' || LOWER(\#(search ?? "")) || '%');
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else { return 0 }
            return try row.decode(column: "count", as: Int.self)
        }
    }
}

private func mediaAssetNodeSQLValues(_ values: [String]) -> String {
    values.map { value in
        let escaped = value.replacingOccurrences(of: "'", with: "''")
        return "'\(escaped)'"
    }
    .joined(separator: ", ")
}
