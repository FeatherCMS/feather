import FeatherDBAL
import Foundation
import MediaModule

extension Variant.Processor {
    struct Table: DatabaseTable {
        static let name = "media_variant_processor"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let id = DatabaseTableColumn<String>(name: "id")
            let variantId = DatabaseTableColumn<String>(name: "variant_id")
            let name = DatabaseTableColumn<String>(name: "name")
            let matchExtensions = DatabaseTableColumn<String>(
                name: "match_extensions"
            )
            let commandTemplate = DatabaseTableColumn<String>(
                name: "command_template"
            )
            let isActive = DatabaseTableColumn<Bool>(name: "is_active")
            let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
