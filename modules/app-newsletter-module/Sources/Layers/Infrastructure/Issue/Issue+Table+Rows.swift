public import FeatherDBAL
public import NewsletterModule

public import struct Foundation.Date

extension Issue.Table: DatabaseTableWithInsert {
    public struct Insert: DatabaseTableRowEncodable {
        public let id: String
        public let newsletterId: String
        public let subject: String
        public let previewText: String
        public let content: String
        public let status: String
        public let scheduledDate: Date?

        enum CodingKeys: String, CodingKey {
            case id
            case newsletterId = "newsletter_id"
            case subject
            case previewText = "preview_text"
            case content
            case status
            case scheduledDate = "scheduled_date"
        }
    }
}

extension Issue.Table: DatabaseTableWithUpdate {
    public struct Update: DatabaseTableRowEncodable {
        public let subject: String
        public let previewText: String
        public let content: String
        public let status: String
        public let scheduledDate: Date?
        public let sentDate: Date?

        public func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Issue.Table.columns.updatedAt] = .currentTimestamp
        }

        enum CodingKeys: String, CodingKey {
            case subject
            case previewText = "preview_text"
            case content
            case status
            case scheduledDate = "scheduled_date"
            case sentDate = "sent_date"
        }
    }
}

extension Issue.Table: DatabaseTableWithDetail {
    public struct Detail: DatabaseTableRowDecodable {
        public let id: String
        public let newsletterId: String
        public let subject: String
        public let previewText: String
        public let content: String
        public let status: String
        public let scheduledDate: Date?
        public let sentDate: Date?
        public let createdAt: Date
        public let updatedAt: Date
    }
}

extension Issue.Table: DatabaseTableWithList {
    public struct List: DatabaseTableRowDecodable {
        public let id: String
        public let newsletterId: String
        public let subject: String
        public let previewText: String
        public let content: String
        public let status: String
        public let scheduledDate: Date?
        public let sentDate: Date?
        public let createdAt: Date
        public let updatedAt: Date
    }
}

extension Issue.Table: DatabaseTableWithDelete {}
