import FeatherDBAL
import MediaModule

extension Asset.File.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let assetNodeId: String
        let storageObjectId: String
        let status: String
        let title: String?
        let altText: String?
    }
}

extension Asset.File.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let status: String?
        let title: String??
        let altText: String??

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
