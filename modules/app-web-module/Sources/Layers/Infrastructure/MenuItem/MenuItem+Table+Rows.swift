import FeatherDBAL
import WebDomain
import WebModule

import struct Foundation.Date

extension MenuItem.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let menuId: String
        let label: String
        let url: String
        let priority: Int
        let isBlank: Bool
        let permission: String
        let authentication: String
        let notes: String?
    }
}

extension MenuItem.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let menuId: String
        let label: String
        let url: String
        let priority: Int
        let isBlank: Bool
        let permission: String
        let authentication: String
        let notes: String?

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[MenuItem.Table.columns.updatedAt] = .currentTimestamp
        }
    }
}

extension MenuItem.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let menuId: String
        let label: String
        let url: String
        let priority: Int
        let isBlank: Bool
        let permission: String
        let authentication: String
        let notes: String?
        let createdAt: Date
        let updatedAt: Date
    }
}

extension MenuItem.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let menuId: String
        let label: String
        let url: String
        let priority: Int
        let isBlank: Bool
        let permission: String
        let authentication: String
        let notes: String?
        let createdAt: Date
        let updatedAt: Date
    }
}

extension MenuItem.Table: DatabaseTableWithDelete {}
