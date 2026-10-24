import FeatherDBAL
import FeatherDatabase
import FeatherInfrastructure
import MediaModule
import Foundation

struct StorageObjectAssociatedQuery {
    let connection: any DatabaseConnection

    func list(assetNodeFileIds: [String]) async throws -> [StorageObject.Table.List] {
        guard !assetNodeFileIds.isEmpty else { return [] }
        return try await connection.run(
            query: #"""
                SELECT DISTINCT object.*
                FROM media_storage_object AS object
                LEFT JOIN media_asset_node_file AS file ON file.storage_object_id = object.id
                LEFT JOIN media_asset_node_file_variant AS variant ON variant.storage_object_id = object.id
                WHERE file.asset_node_id IN (\#(assetNodeFileIds))
                   OR variant.asset_node_file_id IN (\#(assetNodeFileIds))
                ORDER BY object.key, object.extension;
                """#
        ) { sequence in
            try await sequence.collect().map { try StorageObject.Table.List(row: $0) }
        }
    }
}
