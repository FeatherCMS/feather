import FeatherDBAL
import MediaModule

extension Asset.Folder.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let assetNodeId: String
        let assetCount: Int
        let totalSizeBytes: Int64

        enum CodingKeys: String, CodingKey {
            case assetNodeId = "asset_node_id"
            case assetCount = "asset_count"
            case totalSizeBytes = "total_size_bytes"
        }
    }
}

extension Asset.Folder.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let assetCount: Int
        let totalSizeBytes: Int64

        enum CodingKeys: String, CodingKey {
            case assetCount = "asset_count"
            case totalSizeBytes = "total_size_bytes"
        }
    }
}
