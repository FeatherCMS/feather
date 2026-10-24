import FeatherDBAL
import MediaModule

extension Asset.Folder.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let assetNodeId: String
        let assetCount: Int
        let totalSizeBytes: Int64
    }
}

extension Asset.Folder.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let assetCount: Int
        let totalSizeBytes: Int64
    }
}
