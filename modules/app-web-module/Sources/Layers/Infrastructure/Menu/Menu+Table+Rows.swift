import FeatherDBAL
import WebDomain

import struct Foundation.Date

extension Menu.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let key: String
        let name: String
        let notes: String?
    }
    }

    extension Menu.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let key: String
        let name: String
        let notes: String?

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Menu.Table.columns.updatedAt] = .currentTimestamp
        }
    }
    }

    extension Menu.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let key: String
        let name: String
        let notes: String?
        let createdAt: Date
        let updatedAt: Date
    }
    }

    extension Menu.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let key: String
        let name: String
        let createdAt: Date
        let updatedAt: Date
    }
}

extension Menu.Table: DatabaseTableWithDelete {}
