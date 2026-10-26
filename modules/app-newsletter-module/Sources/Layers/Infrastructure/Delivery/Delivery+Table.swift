public import FeatherDBAL
public import struct Foundation.Date
public import NewsletterModule

extension Delivery {
    public struct Table: DatabaseTable {
        public static let name = "newsletter_delivery"
        public static let columns = Columns()

        public struct Columns: DatabaseTableColumns {
            public let issueId = DatabaseTableColumn<String>(name: "issue_id")
            public let newsletterId = DatabaseTableColumn<String>(name: "newsletter_id")
            public let subscriberEmail = DatabaseTableColumn<String>(name: "subscriber_email")
            public let status = DatabaseTableColumn<String>(name: "status")
            public let sentDate = DatabaseTableColumn<Date?>(name: "sent_date")
            public let failureReason = DatabaseTableColumn<String?>(name: "failure_reason")
            public let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            public let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
