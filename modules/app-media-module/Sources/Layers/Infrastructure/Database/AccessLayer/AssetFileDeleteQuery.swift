import FeatherDatabase

import Foundation

struct AssetFileDeleteQuery {
    let connection: any DatabaseConnection

    func delete(ids: [String]) async throws -> [String] {
        guard !ids.isEmpty else { return [] }
        let storageObjectIds = try await connection.run(
            query: #"""
                SELECT storage_object_id AS id
                FROM media_asset_node_file
                WHERE asset_node_id IN (\#(ids))
                UNION
                SELECT storage_object_id AS id
                FROM media_asset_node_file_variant
                WHERE asset_node_file_id IN (\#(ids));
                """#
        ) { sequence in
            try await sequence.collect()
                .map { try $0.decode(column: "id", as: String.self) }
        }

        _ = try await connection.run(
            query:
                #"DELETE FROM media_asset_node_file_variant WHERE asset_node_file_id IN (\#(ids));"#
        ) { _ in }

        let deletedIds = try await connection.run(
            query: #"""
                DELETE FROM media_asset_node
                WHERE id IN (\#(ids))
                  AND EXISTS (SELECT 1 FROM media_asset_node_file f WHERE f.asset_node_id = media_asset_node.id)
                RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect()
                .map { try $0.decode(column: "id", as: String.self) }
        }

        if !storageObjectIds.isEmpty {
            _ = try await connection.run(
                query:
                    #"DELETE FROM media_storage_object WHERE id IN (\#(storageObjectIds));"#
            ) { _ in }
        }

        return deletedIds
    }
}
