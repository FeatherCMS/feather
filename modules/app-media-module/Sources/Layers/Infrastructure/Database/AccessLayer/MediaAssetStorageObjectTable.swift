import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

extension MediaAssetStorageObjectTable.Row {
    init(from row: any DatabaseRow) throws {
        id = try row.decode(column: "id", as: String.self)
        key = try row.decode(column: "key", as: String.self)
        `extension` = try row.decode(column: "extension", as: String.self)
        contentType = try row.decode(column: "content_type", as: String.self)
        sizeInBytes = try row.decode(column: "size_in_bytes", as: Int64.self)
        createdAt = try row.decode(column: "created_at", as: Date.self)
    }
}

struct MediaAssetStorageObjectTable {
    struct Row {
        struct Create {
            let id: String
            let key: String
            let `extension`: String
            let contentType: String
            let sizeInBytes: Int64
        }

        let id: String
        let key: String
        let `extension`: String
        let contentType: String
        let sizeInBytes: Int64
        let createdAt: Date
    }

    let connection: any DatabaseConnection

    func create(row: Row.Create) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO media_storage_object (
                    id, key, extension, content_type, size_in_bytes, created_at
                ) VALUES (
                    \#(row.id), \#(row.key), \#(row.extension), \#(row.contentType),
                    \#(Int(row.sizeInBytes)), NOW()
                )
                RETURNING *;
                """#
        ) { sequence in
            guard let result = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: result)
        }
    }

    func create(rows: [Row.Create]) async throws -> [Row] {
        guard !rows.isEmpty else { return [] }
        let values =
            rows.map { row in
                "(\(sql(row.id)), \(sql(row.key)), \(sql(row.extension)), \(sql(row.contentType)), \(row.sizeInBytes), NOW())"
            }
            .joined(separator: ", ")
        return try await connection.run(
            query:
                #"INSERT INTO media_storage_object (id, key, extension, content_type, size_in_bytes, created_at) VALUES \#(unescaped: values) RETURNING *;"#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func find(storageObjectId: String) async throws -> Row? {
        try await connection.run(
            query:
                #"SELECT * FROM media_storage_object WHERE id = \#(storageObjectId) LIMIT 1;"#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    func list(assetNodeFileIds: [String]) async throws -> [Row] {
        guard !assetNodeFileIds.isEmpty else { return [] }
        let values = assetNodeFileIds.map(sql).joined(separator: ", ")
        return try await connection.run(
            query: #"""
                SELECT DISTINCT o.*
                FROM media_storage_object o
                LEFT JOIN media_asset_node_file f ON f.storage_object_id = o.id
                LEFT JOIN media_asset_node_file_variant v ON v.storage_object_id = o.id
                WHERE f.asset_node_id IN (\#(unescaped: values))
                   OR v.asset_node_file_id IN (\#(unescaped: values))
                ORDER BY o.key ASC, o.extension ASC;
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }
}

private func sql(_ value: String) -> String {
    "'\(value.replacingOccurrences(of: "'", with: "''"))'"
}
