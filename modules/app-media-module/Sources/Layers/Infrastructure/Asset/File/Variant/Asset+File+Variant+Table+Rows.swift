import FeatherDBAL
import Foundation
import MediaModule

extension Asset.File.Variant.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let assetNodeFileId: String
        let variantId: String
        let variantProcessorId: String
        let storageObjectId: String

        enum CodingKeys: String, CodingKey {
            case id
            case assetNodeFileId = "asset_node_file_id"
            case variantId = "variant_id"
            case variantProcessorId = "variant_processor_id"
            case storageObjectId = "storage_object_id"
        }
    }
}

extension Asset.File.Variant.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let assetNodeFileId: String
        let variantId: String
        let variantProcessorId: String
        let storageObjectId: String
        let createdAt: Date

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case assetNodeFileId = "asset_node_file_id"
            case variantId = "variant_id"
            case variantProcessorId = "variant_processor_id"
            case storageObjectId = "storage_object_id"
            case createdAt = "created_at"
        }
    }
}

extension Asset.File.Variant.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let assetNodeFileId: String
        let variantId: String
        let variantProcessorId: String
        let storageObjectId: String
        let createdAt: Date

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case assetNodeFileId = "asset_node_file_id"
            case variantId = "variant_id"
            case variantProcessorId = "variant_processor_id"
            case storageObjectId = "storage_object_id"
            case createdAt = "created_at"
        }
    }
}

extension Asset.File.Variant.Table: DatabaseTableWithDelete {}
