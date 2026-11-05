public import FeatherDBAL
public import Foundation
public import UserModule

extension Identity.Table: DatabaseTableWithDetail {
    public struct Detail: DatabaseTableRowDecodable {
        public let id: String
        public let name: String
        public let status: String
        public let isRoot: Bool
        public let createdAt: Date
        public let updatedAt: Date

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "name"
            case status = "status"
            case isRoot = "is_root"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

extension Identity.Table: DatabaseTableWithList {
    public struct List: DatabaseTableRowDecodable {
        public let id: String
        public let name: String
        public let status: String
        public let isRoot: Bool
        public let createdAt: Date
        public let updatedAt: Date

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "name"
            case status = "status"
            case isRoot = "is_root"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

extension Identity.Table: DatabaseTableWithInsert {
    public struct Insert: DatabaseTableRowEncodable {
        public let id: String
        public let name: String
        public let status: String
        public let isRoot: Bool

        enum CodingKeys: String, CodingKey {
            case id
            case name
            case status
            case isRoot = "is_root"
        }
    }
}

extension Identity.Table: DatabaseTableWithUpdate {
    public struct Update: DatabaseTableRowEncodable {
        public let id: String
        public let name: String
        public let status: String
        public let isRoot: Bool

        public func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Identity.Table.columns.updatedAt] = .currentTimestamp
        }

        enum CodingKeys: String, CodingKey {
            case id
            case name
            case status
            case isRoot = "is_root"
        }
    }
}

extension Identity.Table: DatabaseTableWithDelete {}
