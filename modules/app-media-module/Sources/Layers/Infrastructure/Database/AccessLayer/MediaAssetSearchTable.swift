import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

struct MediaAssetSearchTable {
    struct Row {
        let kind: String
        let id: String
        let parentId: String?
        let name: String
        let path: String?
        let storageKey: String?
        let baseName: String?
        let type: String?
        let sizeBytes: Int64?
        let status: String?
        let title: String?
        let altText: String?
        let assetCount: Int?
        let totalSizeBytes: Int64?
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func list(
        parentId: String?,
        search: String?,
        orderBy: String,
        limit: Int,
        offset: Int
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                WITH entries AS (
                    SELECT
                        'folder' AS kind,
                        0 AS kind_rank,
                        n.id,
                        n.parent_id,
                        n.name,
                        f.path,
                        NULL::text AS storage_key,
                        NULL::text AS base_name,
                        NULL::text AS type,
                        NULL::bigint AS size_bytes,
                        NULL::text AS status,
                        NULL::text AS title,
                        NULL::text AS alt_text,
                        f.asset_count,
                        f.total_size_bytes,
                        n.created_at,
                        n.updated_at
                    FROM media_asset_node n
                    JOIN media_asset_node_folder f ON f.node_id = n.id
                    WHERE n.kind = 'folder'
                      AND n.deleted_at IS NULL
                      AND (
                        (\#(parentId == nil) AND n.parent_id IS NULL)
                        OR n.parent_id = \#(parentId)
                      )
                      AND (
                        \#(search == nil)
                        OR LOWER(n.name) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                        OR LOWER(f.path) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                      )
                    UNION ALL
                    SELECT
                        'file' AS kind,
                        1 AS kind_rank,
                        n.id,
                        n.parent_id,
                        n.name,
                        NULL::text AS path,
                        f.storage_key,
                        f.base_name,
                        f.type,
                        f.size_bytes,
                        f.status,
                        f.title,
                        f.alt_text,
                        NULL::integer AS asset_count,
                        NULL::bigint AS total_size_bytes,
                        n.created_at,
                        n.updated_at
                    FROM media_asset_node n
                    JOIN media_asset_node_file f ON f.node_id = n.id
                    WHERE n.kind = 'file'
                      AND n.deleted_at IS NULL
                      AND (
                        (\#(parentId == nil) AND n.parent_id IS NULL)
                        OR n.parent_id = \#(parentId)
                      )
                      AND (
                        \#(search == nil)
                        OR LOWER(n.id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                        OR LOWER(f.storage_key) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                        OR LOWER(f.base_name) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                        OR LOWER(f.type) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                        OR LOWER(f.status) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                        OR LOWER(COALESCE(f.title, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                        OR LOWER(COALESCE(f.alt_text, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                      )
                )
                SELECT *
                FROM entries
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
                WITH entries AS (
                    SELECT n.id
                    FROM media_asset_node n
                    JOIN media_asset_node_folder f ON f.node_id = n.id
                    WHERE n.kind = 'folder'
                      AND n.deleted_at IS NULL
                      AND (
                        (\#(parentId == nil) AND n.parent_id IS NULL)
                        OR n.parent_id = \#(parentId)
                      )
                      AND (
                        \#(search == nil)
                        OR LOWER(n.name) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                        OR LOWER(f.path) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                      )
                    UNION ALL
                    SELECT n.id
                    FROM media_asset_node n
                    JOIN media_asset_node_file f ON f.node_id = n.id
                    WHERE n.kind = 'file'
                      AND n.deleted_at IS NULL
                      AND (
                        (\#(parentId == nil) AND n.parent_id IS NULL)
                        OR n.parent_id = \#(parentId)
                      )
                      AND (
                        \#(search == nil)
                        OR LOWER(n.id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                        OR LOWER(f.storage_key) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                        OR LOWER(f.base_name) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                        OR LOWER(f.type) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                        OR LOWER(f.status) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                        OR LOWER(COALESCE(f.title, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                        OR LOWER(COALESCE(f.alt_text, '')) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                      )
                )
                SELECT COUNT(*) AS count
                FROM entries;
                """#
        ) { seq in
            guard let row = try await seq.collect().first else { return 0 }
            return try row.decode(column: "count", as: Int.self)
        }
    }
}

extension MediaAssetSearchTable.Row {
    init(from row: DatabaseRow) throws {
        self.kind = try row.decode(column: "kind", as: String.self)
        self.id = try row.decode(column: "id", as: String.self)
        self.parentId = try row.decode(column: "parent_id", as: String?.self)
        self.name = try row.decode(column: "name", as: String.self)
        self.path = try row.decode(column: "path", as: String?.self)
        self.storageKey = try row.decode(
            column: "storage_key",
            as: String?.self
        )
        self.baseName = try row.decode(column: "base_name", as: String?.self)
        self.type = try row.decode(column: "type", as: String?.self)
        self.sizeBytes = try row.decode(
            column: "size_bytes",
            as: Int64?.self
        )
        self.status = try row.decode(column: "status", as: String?.self)
        self.title = try row.decode(column: "title", as: String?.self)
        self.altText = try row.decode(column: "alt_text", as: String?.self)
        self.assetCount = try row.decode(
            column: "asset_count",
            as: Int?.self
        )
        self.totalSizeBytes = try row.decode(
            column: "total_size_bytes",
            as: Int64?.self
        )
        self.createdAt = try row.decode(column: "created_at", as: Date.self)
        self.updatedAt = try row.decode(column: "updated_at", as: Date.self)
    }
}
