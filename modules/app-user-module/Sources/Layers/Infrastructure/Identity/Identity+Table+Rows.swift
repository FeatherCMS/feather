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
    }
}

extension Identity.Table: DatabaseTableWithInsert {
    public struct Insert: DatabaseTableRowEncodable {
        public let id: String
        public let name: String
        public let status: String
        public let isRoot: Bool
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
    }
}

extension Identity.Table: DatabaseTableWithDelete {}
