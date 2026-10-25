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

        enum CodingKeys: String, CodingKey {
            case id
            case key
            case fileExtension = "extension"
            case contentType = "content_type"
            case sizeInBytes = "size_in_bytes"
        }
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
