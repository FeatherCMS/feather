public import FeatherDBAL
public import SystemModule

extension Permission.Table: DatabaseTableWithInsert {
    public struct Insert: DatabaseTableRowEncodable {
        public let id: String
        public let key: String
        public let name: String?
        public let notes: String?
    }
}

extension Permission.Table: DatabaseTableWithUpdate {
    public struct Update: DatabaseTableRowEncodable {
        public let key: String
        public let name: String?
        public let notes: String?

        public func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Permission.Table.columns.updatedAt] = .currentTimestamp
        }
    }
}

extension Permission.Table: DatabaseTableWithDetail {
    public struct Detail: DatabaseTableRowDecodable {
        public let id: String
        public let key: String
        public let name: String?
        public let notes: String?

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case key = "key"
            case name = "name"
            case notes = "notes"
        }
    }
}

extension Permission.Table: DatabaseTableWithList {
    public struct List: DatabaseTableRowDecodable {
        public let id: String
        public let key: String
        public let name: String?
        public let notes: String?

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case key = "key"
            case name = "name"
            case notes = "notes"
        }
    }
}

extension Permission.Table: DatabaseTableWithDelete {}
