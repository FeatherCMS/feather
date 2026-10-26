public import ContactModule
public import FeatherDBAL

public import struct Foundation.Date

extension Form.Table: DatabaseTableWithInsert {
    public struct Insert: DatabaseTableRowEncodable {
        public let id: String
        public let key: String
        public let name: String
        public let successMessage: String
        public let failureMessage: String
        public let redirectUrl: String?

        enum CodingKeys: String, CodingKey {
            case id
            case key
            case name
            case successMessage = "success_message"
            case failureMessage = "failure_message"
            case redirectUrl = "redirect_url"
        }
    }
}

extension Form.Table: DatabaseTableWithUpdate {
    public struct Update: DatabaseTableRowEncodable {
        public let key: String
        public let name: String
        public let successMessage: String
        public let failureMessage: String
        public let redirectUrl: String?

        public func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Form.Table.columns.updatedAt] = .currentTimestamp
        }

        enum CodingKeys: String, CodingKey {
            case key
            case name
            case successMessage = "success_message"
            case failureMessage = "failure_message"
            case redirectUrl = "redirect_url"
        }
    }
}

extension Form.Table: DatabaseTableWithDetail {
    public struct Detail: DatabaseTableRowDecodable {
        public let id: String
        public let key: String
        public let name: String
        public let successMessage: String
        public let failureMessage: String
        public let redirectUrl: String?
        public let createdAt: Date
        public let updatedAt: Date

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case key = "key"
            case name = "name"
            case successMessage = "success_message"
            case failureMessage = "failure_message"
            case redirectUrl = "redirect_url"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

extension Form.Table: DatabaseTableWithList {
    public struct List: DatabaseTableRowDecodable {
        public let id: String
        public let key: String
        public let name: String
        public let successMessage: String
        public let failureMessage: String
        public let redirectUrl: String?
        public let createdAt: Date
        public let updatedAt: Date

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case key = "key"
            case name = "name"
            case successMessage = "success_message"
            case failureMessage = "failure_message"
            case redirectUrl = "redirect_url"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

extension Form.Table: DatabaseTableWithDelete {}
