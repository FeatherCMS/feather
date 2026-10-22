public import FeatherDBAL
public import Foundation
public import UserModule

extension Role.Table: DatabaseTableWithDetail {
    public struct Detail: DatabaseTableRowDecodable {
        public let id: String
        public let key: String
        public let name: String?
        public let notes: String?
        public let createdAt: Date
        public let updatedAt: Date
    }
}

extension Role.Table: DatabaseTableWithList {
    public struct List: DatabaseTableRowDecodable {
        public let id: String
        public let key: String
        public let name: String?
        public let notes: String?
        public let createdAt: Date
        public let updatedAt: Date
    }
}

extension Role.Table: DatabaseTableWithInsert {
    public struct Insert: DatabaseTableRowEncodable {
        public let id: String
        public let key: String
        public let name: String?
        public let notes: String?
    }
}

extension Role.Table: DatabaseTableWithUpdate {
    public struct Update: DatabaseTableRowEncodable {
        public let key: String
        public let name: String?
        public let notes: String?

        public func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Role.Table.columns.updatedAt] = .currentTimestamp
        }
    }
}

extension Role.Table: DatabaseTableWithDelete {}
