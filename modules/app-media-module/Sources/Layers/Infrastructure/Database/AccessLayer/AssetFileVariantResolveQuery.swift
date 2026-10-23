import FeatherDatabase
import MediaModule

struct AssetFileVariantResolveQuery {
    let connection: any DatabaseConnection

    func resolve(
        nodeIds: [String],
        variantKeys: [String]?
    ) async throws -> [Asset.File.Variant.Table.ResolveRow] {
        guard !nodeIds.isEmpty else { return [] }
        if let variantKeys, variantKeys.isEmpty { return [] }
        let query: DatabaseQuery
        if let variantKeys {
            query = #"""
                SELECT file_variant.asset_node_file_id, file_variant.variant_id,
                       variant.variant_key, variant.name, object.extension
                FROM media_asset_node_file_variant AS file_variant
                JOIN media_variant AS variant ON variant.id = file_variant.variant_id
                JOIN media_storage_object AS object
                  ON object.id = file_variant.storage_object_id
                 AND object.key = 'variants/' || variant.variant_key
                WHERE file_variant.asset_node_file_id IN (\#(nodeIds))
                  AND variant.variant_key IN (\#(variantKeys))
                ORDER BY file_variant.asset_node_file_id, variant.variant_key, file_variant.created_at;
                """#
        } else {
            query = #"""
                SELECT file_variant.asset_node_file_id, file_variant.variant_id,
                       variant.variant_key, variant.name, object.extension
                FROM media_asset_node_file_variant AS file_variant
                JOIN media_variant AS variant ON variant.id = file_variant.variant_id
                JOIN media_storage_object AS object
                  ON object.id = file_variant.storage_object_id
                 AND object.key = 'variants/' || variant.variant_key
                WHERE file_variant.asset_node_file_id IN (\#(nodeIds))
                ORDER BY file_variant.asset_node_file_id, variant.variant_key, file_variant.created_at;
                """#
        }
        return try await connection.run(
            query: query
        ) { sequence in
            try await sequence.collect().map { row in
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
                    name: try row.decode(
                        column: "name",
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
}
