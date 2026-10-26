import FeatherDBAL
import SystemModule

extension Variable.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let key: String
        let value: String
        let name: String?
        let notes: String?
    }
}

extension Variable.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let key: String
        let value: String
        let name: String?
        let notes: String?

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Variable.Table.columns.updatedAt] = .currentTimestamp
        }
    }
}

extension Variable.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let key: String
        let value: String
        let name: String?
        let notes: String?

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case key = "key"
            case value = "value"
            case name = "name"
            case notes = "notes"
        }
    }
}

extension Variable.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let key: String
        let value: String
        let name: String?
        let notes: String?

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case key = "key"
            case value = "value"
            case name = "name"
            case notes = "notes"
        }
    }
}

extension Variable.Table: DatabaseTableWithDelete {}
