import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

extension MediaAssetVariantTable.Row {
    init(from row: any DatabaseRow) throws {
        id = try row.decode(column: "id", as: String.self)
        assetNodeFileId = try row.decode(
            column: "asset_node_file_id",
            as: String.self
        )
        variantId = try row.decode(column: "variant_id", as: String.self)
        variantProcessorId = try row.decode(
            column: "variant_processor_id",
            as: String.self
        )
        storageObjectId = try row.decode(
            column: "storage_object_id",
            as: String.self
        )
        createdAt = try row.decode(column: "created_at", as: Date.self)
    }
}

struct MediaAssetVariantTable {
    struct ResolveRow {
        let assetNodeFileId: String
        let id: String
        let key: String
        let name: String
        let `extension`: String
    }

    struct Row {
        struct Create {
            let id: String
            let assetNodeFileId: String
            let variantId: String
            let variantProcessorId: String
            let storageObjectId: String
        }

        let id: String
        let assetNodeFileId: String
        let variantId: String
        let variantProcessorId: String
        let storageObjectId: String
        let createdAt: Date
    }

    let connection: any DatabaseConnection

    func create(row: Row.Create) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO media_asset_node_file_variant (
                    id, asset_node_file_id, variant_id, variant_processor_id, storage_object_id, created_at
                ) VALUES (\#(row.id), \#(row.assetNodeFileId), \#(row.variantId), \#(row.variantProcessorId), \#(row.storageObjectId), NOW())
                RETURNING *;
                """#
        ) { sequence in
            guard let result = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: result)
        }
    }

    func create(rows: [Row.Create]) async throws {
        guard !rows.isEmpty else { return }
        let values =
            rows.map { row in
                "(\(sql(row.id)), \(sql(row.assetNodeFileId)), \(sql(row.variantId)), \(sql(row.variantProcessorId)), \(sql(row.storageObjectId)), NOW())"
            }
            .joined(separator: ", ")
        try await connection.run(
            query:
                #"INSERT INTO media_asset_node_file_variant (id, asset_node_file_id, variant_id, variant_processor_id, storage_object_id, created_at) VALUES \#(unescaped: values);"#
        ) { _ in }
    }

    func find(nodeId: String, variantId: String) async throws -> Row? {
        try await connection.run(
            query:
                #"SELECT * FROM media_asset_node_file_variant WHERE asset_node_file_id = \#(nodeId) AND variant_id = \#(variantId) LIMIT 1;"#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    func list(nodeId: String) async throws -> [Row] {
        try await list(nodeIds: [nodeId])
    }

    func list(nodeIds: [String]) async throws -> [Row] {
        guard !nodeIds.isEmpty else { return [] }
        let values = nodeIds.map(sql).joined(separator: ", ")
        return try await connection.run(
            query:
                #"SELECT * FROM media_asset_node_file_variant WHERE asset_node_file_id IN (\#(unescaped: values)) ORDER BY asset_node_file_id ASC, created_at ASC, id ASC;"#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func resolve(nodeIds: [String], variantKeys: [String]?) async throws
        -> [ResolveRow]
    {
        guard !nodeIds.isEmpty else { return [] }
        if let variantKeys, variantKeys.isEmpty { return [] }
        let nodeValues = nodeIds.map(sql).joined(separator: ", ")
        let variantFilter: String
        if let variantKeys {
            variantFilter =
                "AND mv.variant_key IN (\(variantKeys.map(sql).joined(separator: ", ")))"
        }
        else {
            variantFilter = ""
        }
        return try await connection.run(
            query: #"""
                SELECT v.asset_node_file_id, v.variant_id, mv.variant_key, mv.name,
                       o.extension
                FROM media_asset_node_file_variant v
                JOIN media_variant mv ON mv.id = v.variant_id
                JOIN media_storage_object o
                  ON o.id = v.storage_object_id
                 AND o.key = 'variants/' || mv.variant_key
                WHERE v.asset_node_file_id IN (\#(unescaped: nodeValues)) \#(unescaped: variantFilter)
                ORDER BY v.asset_node_file_id ASC, mv.variant_key ASC, v.created_at ASC;
                """#
        ) { sequence in
            try await sequence.collect()
                .map { row in
                    .init(
                        assetNodeFileId: try row.decode(
                            column: "asset_node_file_id",
                            as: String.self
                        ),
                        id: try row.decode(
                            column: "variant_id",
                            as: String.self
                        ),
                        key: try row.decode(
                            column: "variant_key",
                            as: String.self
                        ),
                        name: try row.decode(column: "name", as: String.self),
                        extension: try row.decode(
                            column: "extension",
                            as: String.self
                        )
                    )
                }
        }
    }

    func deleteAll(nodeId: String) async throws {
        try await deleteAll(nodeIds: [nodeId])
    }

    func deleteAll(nodeIds: [String]) async throws {
        guard !nodeIds.isEmpty else { return }
        let values = nodeIds.map(sql).joined(separator: ", ")
        try await connection.run(
            query:
                #"DELETE FROM media_asset_node_file_variant WHERE asset_node_file_id IN (\#(unescaped: values));"#
        ) { _ in }
    }
}

private func sql(_ value: String) -> String {
    "'\(value.replacingOccurrences(of: "'", with: "''"))'"
}
