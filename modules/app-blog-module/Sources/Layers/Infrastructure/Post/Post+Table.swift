import BlogModule
import FeatherDBAL

import struct Foundation.Date

extension Post {
    struct Table: DatabaseTable {
        static let name = "blog_post"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let id = DatabaseTableColumn<String>(name: "id")
            let title = DatabaseTableColumn<String>(name: "title")
            let excerpt = DatabaseTableColumn<String>(name: "excerpt")
            let content = DatabaseTableColumn<String>(name: "content")
            let imageAssetId = DatabaseTableColumn<String?>(
                name: "image_asset_id"
            )
            let authorIds = DatabaseTableColumn<String>(name: "author_ids")
            let tagIds = DatabaseTableColumn<String>(name: "tag_ids")
            let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
