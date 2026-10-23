public import FeatherDBAL
public import struct Foundation.Date
public import NewsletterModule

extension Subscriber.Table: DatabaseTableWithInsert {
    public struct Insert: DatabaseTableRowEncodable {
        public let newsletterId: String
        public let email: String
        public let status: String
        public let subscriptionDate: Date
        public let unsubscriptionDate: Date?
        public let firstName: String
        public let lastName: String
        public let confirmedAt: Date?
        public let unsubscribeToken: String?
        public let source: String?
        public let lastSentAt: Date?
    }
}

extension Subscriber.Table: DatabaseTableWithUpdate {
    public struct Update: DatabaseTableRowEncodable {
        public let status: String
        public let subscriptionDate: Date
        public let unsubscriptionDate: Date?
        public let firstName: String
        public let lastName: String
        public let confirmedAt: Date?
        public let unsubscribeToken: String?
        public let source: String?
        public let lastSentAt: Date?

        public func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Subscriber.Table.columns.updatedAt] = .currentTimestamp
        }
    }
}

extension Subscriber.Table: DatabaseTableWithDetail {
    public struct Detail: DatabaseTableRowDecodable {
        public let newsletterId: String
        public let email: String
        public let status: String
        public let subscriptionDate: Date
        public let unsubscriptionDate: Date?
        public let firstName: String
        public let lastName: String
        public let confirmedAt: Date?
        public let unsubscribeToken: String?
        public let source: String?
        public let lastSentAt: Date?
        public let createdAt: Date
        public let updatedAt: Date
    }
}

extension Subscriber.Table: DatabaseTableWithList {
    public struct List: DatabaseTableRowDecodable {
        public let newsletterId: String
        public let email: String
        public let status: String
        public let subscriptionDate: Date
        public let unsubscriptionDate: Date?
        public let firstName: String
        public let lastName: String
        public let confirmedAt: Date?
        public let unsubscribeToken: String?
        public let source: String?
        public let lastSentAt: Date?
        public let createdAt: Date
        public let updatedAt: Date
    }
}

extension Subscriber.Table: DatabaseTableWithDelete {}
