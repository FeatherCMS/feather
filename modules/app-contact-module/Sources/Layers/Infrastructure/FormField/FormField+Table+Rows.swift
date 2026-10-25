public import ContactModule
public import FeatherDBAL

public import struct Foundation.Date

extension FormField.Table: DatabaseTableWithInsert {
    public struct Insert: DatabaseTableRowEncodable {
        public let id: String
        public let key: String
        public let type: String
        public let label: String
        public let allowedValues: String
        public let isRequired: Bool

        enum CodingKeys: String, CodingKey {
            case id
            case key
            case type
            case label
            case allowedValues = "allowed_values"
            case isRequired = "is_required"
        }
    }
}

extension FormField.Table: DatabaseTableWithUpdate {
    public struct Update: DatabaseTableRowEncodable {
        public let key: String
        public let type: String
        public let label: String
        public let allowedValues: String
        public let isRequired: Bool

        public func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[FormField.Table.columns.updatedAt] = .currentTimestamp
        }

        enum CodingKeys: String, CodingKey {
            case key
            case type
            case label
            case allowedValues = "allowed_values"
            case isRequired = "is_required"
        }
    }
}

extension FormField.Table: DatabaseTableWithDetail {
    public struct Detail: DatabaseTableRowDecodable {
        public let id: String
        public let key: String
        public let type: String
        public let label: String
        public let allowedValues: String
        public let isRequired: Bool
        public let createdAt: Date
        public let updatedAt: Date
    }
}

extension FormField.Table: DatabaseTableWithList {
    public struct List: DatabaseTableRowDecodable {
        public let id: String
        public let key: String
        public let type: String
        public let label: String
        public let allowedValues: String
        public let isRequired: Bool
        public let createdAt: Date
        public let updatedAt: Date
    }
}

extension FormField.Table: DatabaseTableWithDelete {}
