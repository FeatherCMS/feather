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

        enum CodingKeys: String, CodingKey {
            case id
            case menuId = "menu_id"
            case label
            case url
            case priority
            case isBlank = "is_blank"
            case permission
            case authentication
            case notes
        }
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

        enum CodingKeys: String, CodingKey {
            case menuId = "menu_id"
            case label
            case url
            case priority
            case isBlank = "is_blank"
            case permission
            case authentication
            case notes
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

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case menuId = "menu_id"
            case label = "label"
            case url = "url"
            case priority = "priority"
            case isBlank = "is_blank"
            case permission = "permission"
            case authentication = "authentication"
            case notes = "notes"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
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

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case menuId = "menu_id"
            case label = "label"
            case url = "url"
            case priority = "priority"
            case isBlank = "is_blank"
            case permission = "permission"
            case authentication = "authentication"
            case notes = "notes"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

extension MenuItem.Table: DatabaseTableWithDelete {}
