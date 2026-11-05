import FeatherDBAL
import Foundation
import MediaModule

extension Variant {
    struct Table: DatabaseTable {
        static let name = "media_variant"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let id = DatabaseTableColumn<String>(name: "id")
            let key = DatabaseTableColumn<String>(name: "variant_key")
            let name = DatabaseTableColumn<String>(name: "name")
            let isRequired = DatabaseTableColumn<Bool>(name: "is_required")
            let isActive = DatabaseTableColumn<Bool>(name: "is_active")
            let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
