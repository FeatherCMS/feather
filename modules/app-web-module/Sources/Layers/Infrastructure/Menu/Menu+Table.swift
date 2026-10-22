import FeatherDBAL
import WebDomain

import struct Foundation.Date

extension Menu {
    struct Table: DatabaseTable {
        static let name = "web_menu"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let id = DatabaseTableColumn<String>(name: "id")
            let key = DatabaseTableColumn<String>(name: "key")
            let name = DatabaseTableColumn<String>(name: "name")
            let notes = DatabaseTableColumn<String?>(name: "notes")
            let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
