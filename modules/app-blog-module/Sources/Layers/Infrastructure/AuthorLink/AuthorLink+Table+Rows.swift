import BlogModule
import FeatherDBAL

import struct Foundation.Date

extension AuthorLink.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let authorId: String
        let label: String
        let url: String
        let priority: Int
        let isBlank: Bool
        let permission: String
        let notes: String

        enum CodingKeys: String, CodingKey {
            case id
            case authorId = "author_id"
            case label
            case url
            case priority
            case isBlank = "is_blank"
            case permission
            case notes
        }
    }
}

extension AuthorLink.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let authorId: String
        let label: String
        let url: String
        let priority: Int
        let isBlank: Bool
        let permission: String
        let notes: String

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[AuthorLink.Table.columns.updatedAt] = .currentTimestamp
        }

        enum CodingKeys: String, CodingKey {
            case authorId = "author_id"
            case label
            case url
            case priority
            case isBlank = "is_blank"
            case permission
            case notes
        }
    }
}

extension AuthorLink.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let authorId: String
        let label: String
        let url: String
        let priority: Int
        let isBlank: Bool
        let permission: String
        let notes: String
        let createdAt: Date
        let updatedAt: Date

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case authorId = "author_id"
            case label = "label"
            case url = "url"
            case priority = "priority"
            case isBlank = "is_blank"
            case permission = "permission"
            case notes = "notes"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

extension AuthorLink.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let authorId: String
        let label: String
        let url: String
        let priority: Int
        let isBlank: Bool
        let permission: String
        let createdAt: Date
        let updatedAt: Date

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case authorId = "author_id"
            case label = "label"
            case url = "url"
            case priority = "priority"
            case isBlank = "is_blank"
            case permission = "permission"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

extension AuthorLink.Table: DatabaseTableWithDelete {}
