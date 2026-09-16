//
//  MediaAssetTable.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherInfrastructure

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
        let fileName = row.baseName + (row.type.isEmpty ? "" : ".\(row.type)")
        _ = try await connection.run(
            query: #"""
                INSERT INTO media_asset_node (
                    id, parent_id, kind, name, created_at, updated_at
                ) VALUES (
                    \#(row.id), \#(row.folderId), 'file', \#(fileName), NOW(), NOW()
                );
                """#
        ) { _ in }
        _ = try await connection.run(
            query: #"""
                INSERT INTO media_asset_node_file (
                    node_id, storage_key, base_name, type, size_bytes, status, title, alt_text
                ) VALUES (
                    \#(row.id), \#(row.storageKey), \#(row.baseName), \#(row.type), \#(Int(row.sizeBytes)), \#(row.status), \#(row.title), \#(row.altText)
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
                    n.parent_id AS folder_id,
                    f.storage_key,
                    f.base_name,
                    f.type,
                    f.size_bytes,
                    f.status,
                    f.title,
                    f.alt_text,
                    n.created_at,
                    n.updated_at,
                    n.deleted_at
                FROM media_asset_node n
                JOIN media_asset_node_file f ON f.node_id = n.id
                WHERE n.id = \#(id)
                  AND n.kind = 'file'
                  AND n.deleted_at IS NULL
                LIMIT 1;
                """#
        ) { seq in
            guard let row = try await seq.collect().first else { return nil }
            return try Row(from: row)
        }
    }

    func lookup(
        ids: [String]
    ) async throws -> [Row] {
        guard !ids.isEmpty else { return [] }
        let values =
            ids
            .map {
                "'\($0.replacingOccurrences(of: "'", with: "''"))'"
            }
            .joined(separator: ", ")
        return try await connection.run(
            query: #"""
                SELECT
                    n.id,
                    n.parent_id AS folder_id,
                    f.storage_key,
                    f.base_name,
                    f.type,
                    f.size_bytes,
                    f.status,
                    f.title,
                    f.alt_text,
                    n.created_at,
                    n.updated_at,
                    n.deleted_at
                FROM media_asset_node n
                JOIN media_asset_node_file f ON f.node_id = n.id
                WHERE n.id IN (\#(unescaped: values))
                  AND n.kind = 'file'
                  AND n.deleted_at IS NULL;
                """#
        ) { seq in
            try await seq.collect().map { try Row(from: $0) }
        }
    }

    func find(
        storageKey: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT
                    n.id,
                    n.parent_id AS folder_id,
                    f.storage_key,
                    f.base_name,
                    f.type,
                    f.size_bytes,
                    f.status,
                    f.title,
                    f.alt_text,
                    n.created_at,
                    n.updated_at,
                    n.deleted_at
                FROM media_asset_node n
                JOIN media_asset_node_file f ON f.node_id = n.id
                WHERE f.storage_key = \#(storageKey)
                  AND n.kind = 'file'
                  AND n.deleted_at IS NULL
                LIMIT 1;
                """#
        ) { seq in
            guard let row = try await seq.collect().first else { return nil }
            return try Row(from: row)
        }
    }

    func list(
        storageKeyPrefix: String
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT
                    n.id,
                    n.parent_id AS folder_id,
                    f.storage_key,
                    f.base_name,
                    f.type,
                    f.size_bytes,
                    f.status,
                    f.title,
                    f.alt_text,
                    n.created_at,
                    n.updated_at,
                    n.deleted_at
                FROM media_asset_node n
                JOIN media_asset_node_file f ON f.node_id = n.id
                WHERE f.storage_key LIKE \#(storageKeyPrefix + "%")
                  AND n.kind = 'file'
                  AND n.deleted_at IS NULL
                ORDER BY f.storage_key ASC;
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func update(
        row: Row
    ) async throws -> Row {
        _ = try await connection.run(
            query: #"""
                UPDATE media_asset_node
                SET parent_id = \#(row.folderId),
                    name = \#(row.baseName + (row.type.isEmpty ? "" : ".\(row.type)")),
                    updated_at = NOW()
                WHERE id = \#(row.id)
                  AND kind = 'file'
                  AND deleted_at IS NULL;
                """#
        ) { _ in }
        _ = try await connection.run(
            query: #"""
                UPDATE media_asset_node_file
                SET storage_key = \#(row.storageKey),
                    base_name = \#(row.baseName),
                    type = \#(row.type),
                    size_bytes = \#(Int(row.sizeBytes)),
                    status = \#(row.status),
                    title = \#(row.title),
                    alt_text = \#(row.altText)
                WHERE node_id = \#(row.id)
                  AND EXISTS (
                    SELECT 1 FROM media_asset_node
                    WHERE id = \#(row.id)
                      AND kind = 'file'
                      AND deleted_at IS NULL
                  );
                """#
        ) { _ in }
        guard let result = try await find(id: row.id) else {
            throw RepositoryError.notFound
        }
        return result
    }

    func delete(ids: [String]) async throws -> [String] {
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
                  AND kind = 'file'
                RETURNING id;
                """#
        ) { seq in
            try await seq.collect()
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
                SELECT
                    n.id,
                    n.parent_id AS folder_id,
                    f.storage_key,
                    f.base_name,
                    f.type,
                    f.size_bytes,
                    f.status,
                    f.title,
                    f.alt_text,
                    n.created_at,
                    n.updated_at,
                    n.deleted_at
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
                SELECT
                    n.id,
                    n.parent_id AS folder_id,
                    f.storage_key,
                    f.base_name,
                    f.type,
                    f.size_bytes,
                    f.status,
                    f.title,
                    f.alt_text,
                    n.created_at,
                    n.updated_at,
                    n.deleted_at
                FROM media_asset_node n
                JOIN media_asset_node_file f ON f.node_id = n.id
                WHERE n.kind = 'file'
                  AND n.deleted_at IS NULL
                  AND n.parent_id IN (\#(unescaped: values))
                ORDER BY n.created_at ASC, n.id ASC;
                """#
        ) { seq in
            try await seq.collect().map { try Row(from: $0) }
        }
    }
}
