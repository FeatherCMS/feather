public import FeatherDBAL
public import struct Foundation.Date
public import NewsletterModule

extension Campaign.Table: DatabaseTableWithInsert {
    public struct Insert: DatabaseTableRowEncodable {
        public let id: String
        public let key: String
        public let name: String
        public let fromEmail: String
    }
}

extension Campaign.Table: DatabaseTableWithUpdate {
    public struct Update: DatabaseTableRowEncodable {
        public let key: String
        public let name: String
        public let fromEmail: String

        public func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Campaign.Table.columns.updatedAt] = .currentTimestamp
        }
    }
}

extension Campaign.Table: DatabaseTableWithDetail {
    public struct Detail: DatabaseTableRowDecodable {
        public let id: String
        public let key: String
        public let name: String
        public let fromEmail: String
        public let createdAt: Date
        public let updatedAt: Date
    }
}

extension Campaign.Table: DatabaseTableWithList {
    public struct List: DatabaseTableRowDecodable {
        public let id: String
        public let key: String
        public let name: String
        public let fromEmail: String
        public let createdAt: Date
        public let updatedAt: Date
    }
}

extension Campaign.Table: DatabaseTableWithDelete {}
