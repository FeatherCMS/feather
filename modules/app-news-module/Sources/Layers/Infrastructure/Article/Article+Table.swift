public import FeatherDBAL
public import struct Foundation.Date
public import NewsModule

extension Article {
    public struct Table: DatabaseTable {
        public static let name = "news_article"
        public static let columns = Columns()

        public struct Columns: DatabaseTableColumns {
            public let id = DatabaseTableColumn<String>(name: "id")
            public let title = DatabaseTableColumn<String>(name: "title")
            public let excerpt = DatabaseTableColumn<String>(name: "excerpt")
            public let content = DatabaseTableColumn<String>(name: "content")
            public let imageAssetId = DatabaseTableColumn<String?>(name: "image_asset_id")
            public let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            public let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
