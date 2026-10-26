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
        public func afterEncode(values: inout DatabaseTableRowValues) throws {
            if let scheduledDate {
                values[Issue.Table.columns.scheduledDate] = .value(
                    scheduledDate
                )
            }
            else {
                values[Issue.Table.columns.scheduledDate] = .null
            }
        }

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

            if let scheduledDate {
                values[Issue.Table.columns.scheduledDate] = .value(
                    scheduledDate
                )
            }
            else {
                values[Issue.Table.columns.scheduledDate] = .null
            }
            if let sentDate {
                values[Issue.Table.columns.sentDate] = .value(sentDate)
            }
            else {
                values[Issue.Table.columns.sentDate] = .null
            }
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

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case newsletterId = "newsletter_id"
            case subject = "subject"
            case previewText = "preview_text"
            case content = "content"
            case status = "status"
            case scheduledDate = "scheduled_date"
            case sentDate = "sent_date"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
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

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case newsletterId = "newsletter_id"
            case subject = "subject"
            case previewText = "preview_text"
            case content = "content"
            case status = "status"
            case scheduledDate = "scheduled_date"
            case sentDate = "sent_date"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

extension Issue.Table: DatabaseTableWithDelete {}
