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
    }
}

extension Form.Table: DatabaseTableWithDelete {}
