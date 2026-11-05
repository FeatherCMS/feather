import FeatherDBAL
import Foundation
import MediaModule

extension StorageObject {
    struct Table: DatabaseTable {
        static let name = "media_storage_object"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let id = DatabaseTableColumn<String>(name: "id")
            let key = DatabaseTableColumn<String>(name: "key")
            let fileExtension = DatabaseTableColumn<String>(name: "extension")
            let contentType = DatabaseTableColumn<String>(name: "content_type")
            let sizeInBytes = DatabaseTableColumn<Int64>(name: "size_in_bytes")
            let createdAt = DatabaseTableColumn<Date>(name: "created_at")
        }
    }
}
