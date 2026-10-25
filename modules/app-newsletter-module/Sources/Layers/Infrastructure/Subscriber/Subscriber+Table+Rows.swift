public import FeatherDBAL
public import NewsletterModule

public import struct Foundation.Date

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
        public func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Subscriber.Table.columns.subscriptionDate] = .value(
                subscriptionDate
            )
            if let unsubscriptionDate {
                values[Subscriber.Table.columns.unsubscriptionDate] = .value(
                    unsubscriptionDate
                )
            }
            else {
                values[Subscriber.Table.columns.unsubscriptionDate] = .null
            }
            if let confirmedAt {
                values[Subscriber.Table.columns.confirmedAt] = .value(
                    confirmedAt
                )
            }
            else {
                values[Subscriber.Table.columns.confirmedAt] = .null
            }
            if let lastSentAt {
                values[Subscriber.Table.columns.lastSentAt] = .value(lastSentAt)
            }
            else {
                values[Subscriber.Table.columns.lastSentAt] = .null
            }
        }

        enum CodingKeys: String, CodingKey {
            case newsletterId = "newsletter_id"
            case email
            case status
            case subscriptionDate = "subscription_date"
            case unsubscriptionDate = "unsubscription_date"
            case firstName = "first_name"
            case lastName = "last_name"
            case confirmedAt = "confirmed_at"
            case unsubscribeToken = "unsubscribe_token"
            case source
            case lastSentAt = "last_sent_at"
        }
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

            values[Subscriber.Table.columns.subscriptionDate] = .value(
                subscriptionDate
            )
            if let unsubscriptionDate {
                values[Subscriber.Table.columns.unsubscriptionDate] = .value(
                    unsubscriptionDate
                )
            }
            else {
                values[Subscriber.Table.columns.unsubscriptionDate] = .null
            }
            if let confirmedAt {
                values[Subscriber.Table.columns.confirmedAt] = .value(
                    confirmedAt
                )
            }
            else {
                values[Subscriber.Table.columns.confirmedAt] = .null
            }
            if let lastSentAt {
                values[Subscriber.Table.columns.lastSentAt] = .value(lastSentAt)
            }
            else {
                values[Subscriber.Table.columns.lastSentAt] = .null
            }
        }

        enum CodingKeys: String, CodingKey {
            case status
            case subscriptionDate = "subscription_date"
            case unsubscriptionDate = "unsubscription_date"
            case firstName = "first_name"
            case lastName = "last_name"
            case confirmedAt = "confirmed_at"
            case unsubscribeToken = "unsubscribe_token"
            case source
            case lastSentAt = "last_sent_at"
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
