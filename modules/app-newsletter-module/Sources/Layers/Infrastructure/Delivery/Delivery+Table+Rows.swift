public import FeatherDBAL
public import NewsletterModule

public import struct Foundation.Date

extension Delivery.Table: DatabaseTableWithInsert {
    public struct Insert: DatabaseTableRowEncodable {
        public let issueId: String
        public let newsletterId: String
        public let subscriberEmail: String
        public let status: String
        public let sentDate: Date?
        public let failureReason: String?

        enum CodingKeys: String, CodingKey {
            case issueId = "issue_id"
            case newsletterId = "newsletter_id"
            case subscriberEmail = "subscriber_email"
            case status
            case sentDate = "sent_date"
            case failureReason = "failure_reason"
        }
    }
}

extension Delivery.Table: DatabaseTableWithUpdate {
    public struct Update: DatabaseTableRowEncodable {
        public let status: String
        public let sentDate: Date?
        public let failureReason: String?

        public func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Delivery.Table.columns.updatedAt] = .currentTimestamp
        }

        enum CodingKeys: String, CodingKey {
            case status
            case sentDate = "sent_date"
            case failureReason = "failure_reason"
        }
    }
}

extension Delivery.Table: DatabaseTableWithDetail {
    public struct Detail: DatabaseTableRowDecodable {
        public let issueId: String
        public let newsletterId: String
        public let subscriberEmail: String
        public let status: String
        public let sentDate: Date?
        public let failureReason: String?
        public let createdAt: Date
        public let updatedAt: Date
    }
}

extension Delivery.Table: DatabaseTableWithList {
    public struct List: DatabaseTableRowDecodable {
        public let issueId: String
        public let newsletterId: String
        public let subscriberEmail: String
        public let status: String
        public let sentDate: Date?
        public let failureReason: String?
        public let createdAt: Date
        public let updatedAt: Date
    }
}

extension Delivery.Table: DatabaseTableWithDelete {}
