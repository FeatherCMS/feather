public import FeatherDBAL
public import NewsletterModule

public import struct Foundation.Date

extension Issue {
    public struct Table: DatabaseTable {
        public static let name = "newsletter_issue"
        public static let columns = Columns()

        public struct Columns: DatabaseTableColumns {
            public let id = DatabaseTableColumn<String>(name: "id")
            public let newsletterId = DatabaseTableColumn<String>(
                name: "newsletter_id"
            )
            public let subject = DatabaseTableColumn<String>(name: "subject")
            public let previewText = DatabaseTableColumn<String>(
                name: "preview_text"
            )
            public let content = DatabaseTableColumn<String>(name: "content")
            public let status = DatabaseTableColumn<String>(name: "status")
            public let scheduledDate = DatabaseTableColumn<Date?>(
                name: "scheduled_date"
            )
            public let sentDate = DatabaseTableColumn<Date?>(name: "sent_date")
            public let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            public let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
