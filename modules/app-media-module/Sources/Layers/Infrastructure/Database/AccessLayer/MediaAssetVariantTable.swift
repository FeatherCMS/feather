import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

extension MediaAssetVariantTable.Row {
    init(from row: any DatabaseRow) throws {
        id = try row.decode(column: "id", as: String.self)
        nodeId = try row.decode(column: "asset_id", as: String.self)
        variantId = try row.decode(column: "variant_id", as: String.self)
        variantProcessorId = try row.decode(
            column: "variant_processor_id",
            as: String.self
        )
        name = try row.decode(column: "name", as: String.self)
        storageObjectId = try row.decode(
            column: "storage_object_id",
            as: String.self
        )
        objectKey = try row.decode(column: "object_key", as: String.self)
        `extension` = try row.decode(column: "extension", as: String.self)
        createdAt = try row.decode(column: "created_at", as: Date.self)
    }
}

struct MediaAssetVariantTable {
    struct ResolveRow {
        let nodeId: String
        let id: String
        let key: String
        let name: String
        let objectKey: String
        let `extension`: String
    }

    struct Row {
        struct Create {
            let id: String
            let nodeId: String
            let variantId: String
            let variantProcessorId: String
            let name: String
            let storageObjectId: String
            let `extension`: String
        }

        let id: String
        let nodeId: String
        let variantId: String
        let variantProcessorId: String
        let name: String
        let storageObjectId: String
        let objectKey: String
        let `extension`: String
        let createdAt: Date
    }

    let connection: any DatabaseConnection

    func create(row: Row.Create) async throws -> Row {
        _ = try await connection.run(
            query: #"""
                INSERT INTO media_asset_variant (
                    id, asset_id, variant_id, variant_processor_id, name, storage_object_id, extension, created_at
                ) VALUES (
                    \#(row.id), \#(row.nodeId), \#(row.variantId), \#(row.variantProcessorId), \#(row.name),
                    \#(row.storageObjectId), \#(row.extension), NOW()
                )
                """#
        ) { _ in }
        guard
            let result = try await find(
                nodeId: row.nodeId,
                variantId: row.variantId
            )
        else {
            throw RepositoryError.notFound
        }
        return result
    }

    func create(rows: [Row.Create]) async throws {
        guard !rows.isEmpty else { return }
        let values =
            rows.map { row in
                let id = row.id.replacingOccurrences(of: "'", with: "''")
                let nodeID = row.nodeId.replacingOccurrences(
                    of: "'",
                    with: "''"
                )
                let variantID = row.variantId.replacingOccurrences(
                    of: "'",
                    with: "''"
                )
                let processorID = row.variantProcessorId.replacingOccurrences(
                    of: "'",
                    with: "''"
                )
                let name = row.name.replacingOccurrences(of: "'", with: "''")
                let storageObjectID = row.storageObjectId.replacingOccurrences(
                    of: "'",
                    with: "''"
                )
                let fileExtension = row.extension.replacingOccurrences(
                    of: "'",
                    with: "''"
                )
                return
                    "('\(id)', '\(nodeID)', '\(variantID)', '\(processorID)', '\(name)', '\(storageObjectID)', '\(fileExtension)', NOW())"
            }
            .joined(separator: ", ")
        try await connection.run(
            query:
                #"INSERT INTO media_asset_variant (id, asset_id, variant_id, variant_processor_id, name, storage_object_id, extension, created_at) VALUES \#(unescaped: values);"#
        ) { _ in }
    }

    func find(nodeId: String, variantId: String) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT v.id, v.asset_id, v.variant_id, v.variant_processor_id, v.name, v.storage_object_id,
                       o.object_key, v.extension, v.created_at
                FROM media_asset_variant v
                JOIN media_asset_storage_object o ON o.id = v.storage_object_id
                WHERE v.asset_id = \#(nodeId) AND v.variant_id = \#(variantId)
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    func list(nodeId: String) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT v.id, v.asset_id, v.variant_id, v.variant_processor_id, v.name, v.storage_object_id,
                       o.object_key, v.extension, v.created_at
                FROM media_asset_variant v
                JOIN media_asset_storage_object o ON o.id = v.storage_object_id
                WHERE v.asset_id = \#(nodeId)
                ORDER BY v.created_at ASC, v.id ASC;
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func list(nodeIds: [String]) async throws -> [Row] {
        guard !nodeIds.isEmpty else { return [] }
        let values = mediaVariantSQLValues(nodeIds)
        return try await connection.run(
            query: #"""
                SELECT v.id, v.asset_id, v.variant_id, v.variant_processor_id, v.name, v.storage_object_id,
                       o.object_key, v.extension, v.created_at
                FROM media_asset_variant v
                JOIN media_asset_storage_object o ON o.id = v.storage_object_id
                WHERE v.asset_id IN (\#(unescaped: values))
                ORDER BY v.asset_id ASC, v.created_at ASC, v.id ASC;
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func resolve(nodeIds: [String], variantKeys: [String]?) async throws
        -> [ResolveRow]
    {
        guard !nodeIds.isEmpty else { return [] }
        if let variantKeys, variantKeys.isEmpty { return [] }
        let nodeValues = mediaVariantSQLValues(nodeIds)
        let variantFilter: String
        if let variantKeys {
            let values = mediaVariantSQLValues(variantKeys)
            variantFilter = "AND mv.variant_key IN (\(values))"
        }
        else {
            variantFilter = ""
        }
        return try await connection.run(
            query: #"""
                SELECT v.asset_id, v.variant_id, mv.variant_key, v.name, o.object_key, v.extension
                FROM media_asset_variant v
                JOIN media_variant mv ON mv.id = v.variant_id
                JOIN media_asset_storage_object o ON o.id = v.storage_object_id
                WHERE v.asset_id IN (\#(unescaped: nodeValues)) \#(unescaped: variantFilter)
                ORDER BY v.asset_id ASC, v.name ASC, v.created_at ASC;
                """#
        ) { sequence in
            try await sequence.collect()
                .map { row in
                    .init(
                        nodeId: try row.decode(
                            column: "asset_id",
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
                        objectKey: try row.decode(
                            column: "object_key",
                            as: String.self
                        ),
                        extension: try row.decode(
                            column: "extension",
                            as: String.self
                        )
                    )
                }
        }
    }

    func deleteAll(nodeId: String) async throws {
        try await connection.run(
            query:
                #"DELETE FROM media_asset_variant WHERE asset_id = \#(nodeId);"#
        ) { _ in }
    }

    func deleteAll(nodeIds: [String]) async throws {
        guard !nodeIds.isEmpty else { return }
        let values = mediaVariantSQLValues(nodeIds)
        try await connection.run(
            query:
                #"DELETE FROM media_asset_variant WHERE asset_id IN (\#(unescaped: values));"#
        ) { _ in }
    }
}

private func mediaVariantSQLValues(_ values: [String]) -> String {
    values.map { value in
        let escaped = value.replacingOccurrences(of: "'", with: "''")
        return "'\(escaped)'"
    }
    .joined(separator: ", ")
}
