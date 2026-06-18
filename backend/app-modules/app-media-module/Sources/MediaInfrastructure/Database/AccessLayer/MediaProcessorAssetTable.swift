import FeatherDatabase
import Infrastructure
import struct Foundation.Date

extension MediaProcessorAssetTable.Row {
    init(from row: DatabaseRow) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.assetId = try row.decode(column: "asset_id", as: String.self)
        self.processorId = try row.decode(
            column: "processor_id",
            as: String.self
        )
        self.storageKey = try row.decode(column: "storage_key", as: String.self)
        self.createdAt = try row.decode(column: "created_at", as: Date.self)
    }
}

struct MediaProcessorAssetTable {
    struct Row {
        struct Create {
            let id: String
            let assetId: String
            let processorId: String
            let storageKey: String
        }

        let id: String
        let assetId: String
        let processorId: String
        let storageKey: String
        let createdAt: Date
    }

    let connection: any DatabaseConnection

    func create(
        row: Row.Create
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO media_processor_asset (id, asset_id, processor_id, storage_key, created_at)
                VALUES (
                    \#(row.id), \#(row.assetId), \#(row.processorId), \#(row.storageKey), NOW()
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

    func find(
        assetId: String,
        processorId: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM media_processor_asset
                WHERE asset_id = \#(assetId)
                  AND processor_id = \#(processorId)
                LIMIT 1;
                """#
        ) { seq in
            guard let row = try await seq.collect().first else { return nil }
            return try Row(from: row)
        }
    }

    func list(
        assetId: String
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT *
                FROM media_processor_asset
                WHERE asset_id = \#(assetId)
                ORDER BY created_at ASC;
                """#
        ) { seq in
            try await seq.collect().map { try Row(from: $0) }
        }
    }

    func deleteAll(
        assetId: String
    ) async throws {
        try await connection.run(
            query: #"""
                DELETE FROM media_processor_asset
                WHERE asset_id = \#(assetId);
                """#
        ) { _ in }
    }
}
