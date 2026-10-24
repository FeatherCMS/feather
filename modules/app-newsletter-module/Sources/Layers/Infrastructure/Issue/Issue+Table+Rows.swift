public import FeatherDBAL
public import struct Foundation.Date
public import NewsletterModule

extension Issue.Table: DatabaseTableWithInsert {
    public struct Insert: DatabaseTableRowEncodable {
        public let id: String
        public let newsletterId: String
        public let subject: String
        public let previewText: String
        public let content: String
        public let status: String
        public let scheduledDate: Date?
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
