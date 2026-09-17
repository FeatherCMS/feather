import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

extension MediaAssetNodeFolderTable.Row {
    init(from row: DatabaseRow) throws {
        id = try row.decode(column: "id", as: String.self)
        parentId = try row.decode(column: "parent_id", as: String?.self)
        name = try row.decode(column: "name", as: String.self)
        slug = try row.decode(column: "slug", as: String.self)
        slugPath = try row.decode(column: "slug_path", as: String.self)
        assetCount = try row.decode(column: "asset_count", as: Int.self)
        totalSizeBytes = try row.decode(column: "total_size_bytes", as: Int64.self)
        createdAt = try row.decode(column: "created_at", as: Date.self)
        updatedAt = try row.decode(column: "updated_at", as: Date.self)
        deletedAt = try row.decode(column: "deleted_at", as: Date?.self)
    }
}

struct MediaAssetNodeFolderTable {
    struct Row {
        struct Create {
            let id: String
            let parentId: String?
            let name: String
            let slug: String
            let slugPath: String
            let assetCount: Int
            let totalSizeBytes: Int64
        }

        let id: String
        let parentId: String?
        let name: String
        let slug: String
        let slugPath: String
        let assetCount: Int
        let totalSizeBytes: Int64
        let createdAt: Date
        let updatedAt: Date
        let deletedAt: Date?
    }

    let connection: any DatabaseConnection

    func create(row: Row.Create) async throws -> Row {
        _ = try await MediaAssetNodeTable(connection: connection).create(
            row: .init(
                id: row.id,
                parentId: row.parentId,
                name: row.name,
                slug: row.slug,
                slugPath: row.slugPath
            )
        )
        _ = try await connection.run(
            query: #"""
                INSERT INTO media_asset_node_folder (node_id, asset_count, total_size_bytes)
                VALUES (\#(row.id), \#(row.assetCount), \#(Int(row.totalSizeBytes)));
                """#
        ) { _ in }
        guard let result = try await find(id: row.id) else {
            throw RepositoryError.notFound
        }
        return result
    }

    func update(row: Row) async throws -> Row {
        _ = try await MediaAssetNodeTable(connection: connection).update(
            row: .init(
                id: row.id,
                parentId: row.parentId,
                name: row.name,
                slug: row.slug,
                slugPath: row.slugPath
            )
        )
        _ = try await connection.run(
            query: #"""
                UPDATE media_asset_node_folder
                SET asset_count = \#(row.assetCount), total_size_bytes = \#(Int(row.totalSizeBytes))
                WHERE node_id = \#(row.id);
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
                SELECT n.id, n.parent_id, n.name, n.slug, n.slug_path,
                       f.asset_count, f.total_size_bytes,
                       n.created_at, n.updated_at, n.deleted_at
                FROM media_asset_node n
                JOIN media_asset_node_folder f ON f.node_id = n.id
                WHERE n.id = \#(id) AND n.deleted_at IS NULL
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else { return nil }
            return try Row(from: row)
        }
    }

    func find(slugPath: String) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT n.id, n.parent_id, n.name, n.slug, n.slug_path,
                       f.asset_count, f.total_size_bytes,
                       n.created_at, n.updated_at, n.deleted_at
                FROM media_asset_node n
                JOIN media_asset_node_folder f ON f.node_id = n.id
                WHERE n.slug_path = \#(slugPath) AND n.deleted_at IS NULL
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else { return nil }
            return try Row(from: row)
        }
    }

    func list(parentId: String?) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT n.id, n.parent_id, n.name, n.slug, n.slug_path,
                       f.asset_count, f.total_size_bytes,
                       n.created_at, n.updated_at, n.deleted_at
                FROM media_asset_node n
                JOIN media_asset_node_folder f ON f.node_id = n.id
                WHERE n.deleted_at IS NULL
                  AND ((\#(parentId == nil) AND n.parent_id IS NULL) OR n.parent_id = \#(parentId))
                ORDER BY LOWER(n.name) ASC, n.id ASC;
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func listDescendants(slugPath: String) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT n.id, n.parent_id, n.name, n.slug, n.slug_path,
                       f.asset_count, f.total_size_bytes,
                       n.created_at, n.updated_at, n.deleted_at
                FROM media_asset_node n
                JOIN media_asset_node_folder f ON f.node_id = n.id
                WHERE n.deleted_at IS NULL
                  AND (n.slug_path = \#(slugPath) OR n.slug_path LIKE \#(slugPath + "/%"))
                ORDER BY LENGTH(n.slug_path) ASC, LOWER(n.name) ASC, n.id ASC;
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func delete(ids: [String]) async throws -> [String] {
        guard !ids.isEmpty else { return [] }
        let values = mediaFolderSQLValues(ids)
        return try await connection.run(
            query: #"""
                DELETE FROM media_asset_node
                WHERE id IN (\#(unescaped: values))
                  AND EXISTS (SELECT 1 FROM media_asset_node_folder f WHERE f.node_id = media_asset_node.id)
                RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect().map { try $0.decode(column: "id", as: String.self) }
        }
    }
}

private func mediaFolderSQLValues(_ values: [String]) -> String {
    values.map { value in
        let escaped = value.replacingOccurrences(of: "'", with: "''")
        return "'\(escaped)'"
    }.joined(separator: ", ")
}
