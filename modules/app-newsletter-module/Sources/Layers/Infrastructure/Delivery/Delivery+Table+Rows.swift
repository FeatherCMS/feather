public import FeatherDBAL
public import struct Foundation.Date
public import NewsletterModule

extension Delivery.Table: DatabaseTableWithInsert {
    public struct Insert: DatabaseTableRowEncodable {
        public let issueId: String
        public let newsletterId: String
        public let subscriberEmail: String
        public let status: String
        public let sentDate: Date?
        public let failureReason: String?
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
