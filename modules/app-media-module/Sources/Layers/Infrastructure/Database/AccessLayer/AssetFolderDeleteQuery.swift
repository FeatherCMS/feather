import FeatherDatabase

import Foundation

struct AssetFolderDeleteQuery {
    let connection: any DatabaseConnection

    func delete(ids: [String]) async throws -> [String] {
        guard !ids.isEmpty else { return [] }

        return try await connection.run(
            query: #"""
                DELETE FROM media_asset_node
                WHERE id IN (\#(ids))
                  AND EXISTS (SELECT 1 FROM media_asset_node_folder f WHERE f.asset_node_id = media_asset_node.id)
                RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect()
                .map { try $0.decode(column: "id", as: String.self) }
        }
    }
}
