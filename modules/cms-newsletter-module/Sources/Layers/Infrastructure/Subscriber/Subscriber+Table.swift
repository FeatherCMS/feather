public import FeatherDBAL
public import NewsletterModule

public import struct Foundation.Date

extension Subscriber {
    public struct Table: DatabaseTable {
        public static let name = "newsletter_subscriber"
        public static let columns = Columns()

        public struct Columns: DatabaseTableColumns {
            public let newsletterId = DatabaseTableColumn<String>(
                name: "newsletter_id"
            )
            public let email = DatabaseTableColumn<String>(name: "email")
            public let status = DatabaseTableColumn<String>(name: "status")
            public let subscriptionDate = DatabaseTableColumn<Date>(
                name: "subscription_date"
            )
            public let unsubscriptionDate = DatabaseTableColumn<Date?>(
                name: "unsubscription_date"
            )
            public let firstName = DatabaseTableColumn<String>(
                name: "first_name"
            )
            public let lastName = DatabaseTableColumn<String>(name: "last_name")
            public let confirmedAt = DatabaseTableColumn<Date?>(
                name: "confirmed_at"
            )
            public let unsubscribeToken = DatabaseTableColumn<String?>(
                name: "unsubscribe_token"
            )
            public let source = DatabaseTableColumn<String?>(name: "source")
            public let lastSentAt = DatabaseTableColumn<Date?>(
                name: "last_sent_at"
            )
            public let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            public let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
