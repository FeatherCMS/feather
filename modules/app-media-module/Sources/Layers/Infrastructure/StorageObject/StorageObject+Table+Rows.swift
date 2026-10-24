import FeatherDBAL
import Foundation
import MediaModule

extension StorageObject.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let key: String
        let fileExtension: String
        let contentType: String
        let sizeInBytes: Int64
    }
}

extension StorageObject.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let key: String
        let fileExtension: String
        let contentType: String
        let sizeInBytes: Int64
        let createdAt: Date
    }
}

extension StorageObject.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let key: String
        let fileExtension: String
        let contentType: String
        let sizeInBytes: Int64
        let createdAt: Date
    }
}
