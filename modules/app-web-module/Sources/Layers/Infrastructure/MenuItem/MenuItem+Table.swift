import FeatherDBAL
import WebDomain
import WebModule

import struct Foundation.Date

extension MenuItem {
    struct Table: DatabaseTable {
        static let name = "web_menu_item"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let id = DatabaseTableColumn<String>(name: "id")
            let menuId = DatabaseTableColumn<String>(name: "menu_id")
            let label = DatabaseTableColumn<String>(name: "label")
            let url = DatabaseTableColumn<String>(name: "url")
            let priority = DatabaseTableColumn<Int>(name: "priority")
            let isBlank = DatabaseTableColumn<Bool>(name: "is_blank")
            let permission = DatabaseTableColumn<String>(name: "permission")
            let authentication = DatabaseTableColumn<String>(
                name: "authentication"
            )
            let notes = DatabaseTableColumn<String?>(name: "notes")
            let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
