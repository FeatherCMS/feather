public import FeatherDBAL
public import struct Foundation.Date
public import NewsletterModule

extension Campaign {
    public struct Table: DatabaseTable {
        public static let name = "newsletter_campaign"
        public static let columns = Columns()

        public struct Columns: DatabaseTableColumns {
            public let id = DatabaseTableColumn<String>(name: "id")
            public let key = DatabaseTableColumn<String>(name: "key")
            public let name = DatabaseTableColumn<String>(name: "name")
            public let fromEmail = DatabaseTableColumn<String>(name: "from_email")
            public let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            public let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
