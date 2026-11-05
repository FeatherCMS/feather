import FeatherDBAL
import MediaModule

extension Asset.File.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let assetNodeId: String
        let storageObjectId: String
        let status: String
        let title: String?
        let altText: String?

        enum CodingKeys: String, CodingKey {
            case assetNodeId = "asset_node_id"
            case storageObjectId = "storage_object_id"
            case status
            case title
            case altText = "alt_text"
        }
    }
}

extension Asset.File.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let status: String?
        let title: String??
        let altText: String??

        enum CodingKeys: String, CodingKey {
            case status
            case title
            case altText = "alt_text"
        }

        init(
            status: String,
            title: String?,
            altText: String?
        ) {
            self.status = status
            self.title = .some(title)
            self.altText = .some(altText)
        }

        init(status: String) {
            self.status = status
            title = nil
            altText = nil
        }
    }
}
