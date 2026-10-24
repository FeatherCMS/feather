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
    }
}

extension Asset.File.Variant.Table: DatabaseTableWithDelete {}
