import BlogModule
import FeatherDBAL

import struct Foundation.Date

extension AuthorLink {
    struct Table: DatabaseTable {
        static let name = "blog_author_link"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let id = DatabaseTableColumn<String>(name: "id")
            let authorId = DatabaseTableColumn<String>(name: "author_id")
            let label = DatabaseTableColumn<String>(name: "label")
            let url = DatabaseTableColumn<String>(name: "url")
            let priority = DatabaseTableColumn<Int>(name: "priority")
            let isBlank = DatabaseTableColumn<Bool>(name: "is_blank")
            let permission = DatabaseTableColumn<String>(name: "permission")
            let notes = DatabaseTableColumn<String>(name: "notes")
            let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
