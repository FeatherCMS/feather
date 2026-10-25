public import FeatherDBAL
public import NewsletterModule

public import struct Foundation.Date

extension Campaign.Table: DatabaseTableWithInsert {
    public struct Insert: DatabaseTableRowEncodable {
        public let id: String
        public let key: String
        public let name: String
        public let fromEmail: String

        enum CodingKeys: String, CodingKey {
            case id
            case key
            case name
            case fromEmail = "from_email"
        }
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

        enum CodingKeys: String, CodingKey {
            case key
            case name
            case fromEmail = "from_email"
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

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case key = "key"
            case name = "name"
            case fromEmail = "from_email"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
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

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case key = "key"
            case name = "name"
            case fromEmail = "from_email"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

extension Campaign.Table: DatabaseTableWithDelete {}
