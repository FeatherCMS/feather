import SystemModule
import FeatherDBAL

extension Permission.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let key: String
        let name: String?
        let notes: String?
    }
}

extension Permission.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let key: String
        let name: String?
        let notes: String?

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Permission.Table.columns.updatedAt] = .currentTimestamp
        }
    }
}

extension Permission.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let key: String
        let name: String?
        let notes: String?
    }
}

extension Permission.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let key: String
        let name: String?
        let notes: String?
    }
}

extension Permission.Table: DatabaseTableWithDelete {}
