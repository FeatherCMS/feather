import FeatherDBAL
import Foundation
import MediaModule

extension Asset.File.Variant {
    struct Table: DatabaseTable {
        static let name = "media_asset_node_file_variant"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let id = DatabaseTableColumn<String>(name: "id")
            let assetNodeFileId = DatabaseTableColumn<String>(name: "asset_node_file_id")
            let variantId = DatabaseTableColumn<String>(name: "variant_id")
            let variantProcessorId = DatabaseTableColumn<String>(name: "variant_processor_id")
            let storageObjectId = DatabaseTableColumn<String>(name: "storage_object_id")
            let createdAt = DatabaseTableColumn<Date>(name: "created_at")
        }
    }
}
