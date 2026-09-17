import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

extension MediaAssetStorageObjectTable.Row {
    init(from row: DatabaseRow) throws {
        id = try row.decode(column: "id", as: String.self)
        objectKey = try row.decode(column: "object_key", as: String.self)
        createdAt = try row.decode(column: "created_at", as: Date.self)
        deletedAt = try row.decode(column: "deleted_at", as: Date?.self)
    }
}

struct MediaAssetStorageObjectTable {
    struct Row {
        struct Create {
            let id: String
            let objectKey: String
        }

        let id: String
        let objectKey: String
        let createdAt: Date
        let deletedAt: Date?
    }

    let connection: any DatabaseConnection

    func create(row: Row.Create) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO media_asset_storage_object (id, object_key, created_at)
                VALUES (\#(row.id), \#(row.objectKey), NOW())
                RETURNING *;
                """#
        ) { sequence in
            guard let result = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: result)
        }
    }

    func delete(ids: [String]) async throws -> [String] {
        guard !ids.isEmpty else { return [] }
        let values = mediaStorageObjectSQLValues(ids)
        return try await connection.run(
            query: #"""
                DELETE FROM media_asset_storage_object
                WHERE id IN (\#(unescaped: values))
                RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect().map { try $0.decode(column: "id", as: String.self) }
        }
    }
}

private func mediaStorageObjectSQLValues(_ values: [String]) -> String {
    values.map { value in
        let escaped = value.replacingOccurrences(of: "'", with: "''")
        return "'\(escaped)'"
    }.joined(separator: ", ")
}
