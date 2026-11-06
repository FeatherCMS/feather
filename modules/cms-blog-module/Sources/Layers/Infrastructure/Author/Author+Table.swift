import BlogModule
import FeatherDBAL

import struct Foundation.Date

extension Author {
    struct Table: DatabaseTable {
        static let name = "blog_author"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let id = DatabaseTableColumn<String>(name: "id")
            let key = DatabaseTableColumn<String>(name: "key")
            let name = DatabaseTableColumn<String>(name: "name")
            let notes = DatabaseTableColumn<String>(name: "notes")
            let excerpt = DatabaseTableColumn<String>(name: "excerpt")
            let profileImageAssetId = DatabaseTableColumn<String?>(
                name: "profile_image_asset_id"
            )
            let content = DatabaseTableColumn<String>(name: "content")
            let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
