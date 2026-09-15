//
//  MediaFolderTable.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherInfrastructure

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
        _ = try await connection.run(
            query: #"""
                INSERT INTO media_asset_node (
                    id, parent_id, kind, name, created_at, updated_at
                ) VALUES (
                    \#(row.id), \#(row.parentId), 'folder', \#(row.name), NOW(), NOW()
                );
                """#
        ) { _ in }
        _ = try await connection.run(
            query: #"""
                INSERT INTO media_asset_node_folder (
                    node_id, path, asset_count, total_size_bytes
                ) VALUES (
                    \#(row.id), \#(row.path), \#(row.assetCount), \#(Int(row.totalSizeBytes))
                );
                """#
        ) { _ in }
        guard let result = try await find(id: row.id) else {
            throw RepositoryError.notFound
        }
        return result
    }

    func update(
        row: Row
    ) async throws -> Row {
        _ = try await connection.run(
            query: #"""
                UPDATE media_asset_node
                SET parent_id = \#(row.parentId),
                    name = \#(row.name),
                    updated_at = NOW()
                WHERE id = \#(row.id)
                  AND kind = 'folder'
                  AND deleted_at IS NULL;
                """#
        ) { _ in }
        _ = try await connection.run(
            query: #"""
                UPDATE media_asset_node_folder
                SET path = \#(row.path),
                    asset_count = \#(row.assetCount),
                    total_size_bytes = \#(Int(row.totalSizeBytes))
                WHERE node_id = \#(row.id)
                  AND EXISTS (
                    SELECT 1 FROM media_asset_node
                    WHERE id = \#(row.id)
                      AND kind = 'folder'
                      AND deleted_at IS NULL
                  );
                """#
        ) { _ in }
        guard let result = try await find(id: row.id) else {
            throw RepositoryError.notFound
        }
        return result
    }

    func find(
        id: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT
                    n.id,
                    n.parent_id,
                    n.name,
                    f.path,
                    f.asset_count,
                    f.total_size_bytes,
                    n.created_at,
                    n.updated_at,
                    n.deleted_at
                FROM media_asset_node n
                JOIN media_asset_node_folder f ON f.node_id = n.id
                WHERE n.id = \#(id)
                  AND n.kind = 'folder'
                  AND n.deleted_at IS NULL
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
                SELECT
                    n.id,
                    n.parent_id,
                    n.name,
                    f.path,
                    f.asset_count,
                    f.total_size_bytes,
                    n.created_at,
                    n.updated_at,
                    n.deleted_at
                FROM media_asset_node n
                JOIN media_asset_node_folder f ON f.node_id = n.id
                WHERE f.path = \#(path)
                  AND n.kind = 'folder'
                  AND n.deleted_at IS NULL
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
                SELECT
                    n.id,
                    n.parent_id,
                    n.name,
                    f.path,
                    f.asset_count,
                    f.total_size_bytes,
                    n.created_at,
                    n.updated_at,
                    n.deleted_at
                FROM media_asset_node n
                JOIN media_asset_node_folder f ON f.node_id = n.id
                WHERE n.kind = 'folder'
                  AND n.deleted_at IS NULL
                  AND (
                    (\#(parentId == nil) AND n.parent_id IS NULL)
                    OR n.parent_id = \#(parentId)
                  )
                ORDER BY LOWER(n.name) ASC, n.id ASC;
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
                SELECT
                    n.id,
                    n.parent_id,
                    n.name,
                    f.path,
                    f.asset_count,
                    f.total_size_bytes,
                    n.created_at,
                    n.updated_at,
                    n.deleted_at
                FROM media_asset_node n
                JOIN media_asset_node_folder f ON f.node_id = n.id
                WHERE n.kind = 'folder'
                  AND n.deleted_at IS NULL
                  AND (
                    f.path = \#(path)
                    OR f.path LIKE \#(path + "/%")
                  )
                ORDER BY LENGTH(f.path) ASC, LOWER(n.name) ASC, n.id ASC;
                """#
        ) { seq in
            try await seq.collect().map { try Row(from: $0) }
        }
    }

    func delete(
        ids: [String]
    ) async throws -> [String] {
        guard !ids.isEmpty else { return [] }
        let values =
            ids.map {
                "'\($0.replacingOccurrences(of: "'", with: "''"))'"
            }
            .joined(separator: ", ")
        return try await connection.run(
            query: #"""
                DELETE FROM media_asset_node
                WHERE id IN (\#(unescaped: values))
                  AND kind = 'folder'
                RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect()
                .map {
                    try $0.decode(column: "id", as: String.self)
                }
        }
    }
}
