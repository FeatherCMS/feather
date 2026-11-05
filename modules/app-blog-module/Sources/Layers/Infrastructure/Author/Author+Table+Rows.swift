import BlogModule
import FeatherDBAL

import struct Foundation.Date

extension Author.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let key: String
        let name: String
        let notes: String
        let excerpt: String
        let profileImageAssetId: String?
        let content: String

        enum CodingKeys: String, CodingKey {
            case id
            case key
            case name
            case notes
            case excerpt
            case profileImageAssetId = "profile_image_asset_id"
            case content
        }
    }
}

extension Author.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let key: String
        let name: String
        let notes: String
        let excerpt: String
        let profileImageAssetId: String?
        let content: String

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Author.Table.columns.updatedAt] = .currentTimestamp
        }

        enum CodingKeys: String, CodingKey {
            case key
            case name
            case notes
            case excerpt
            case profileImageAssetId = "profile_image_asset_id"
            case content
        }
    }
}

extension Author.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let key: String
        let name: String
        let notes: String
        let excerpt: String
        let profileImageAssetId: String?
        let content: String
        let createdAt: Date
        let updatedAt: Date

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case key = "key"
            case name = "name"
            case notes = "notes"
            case excerpt = "excerpt"
            case profileImageAssetId = "profile_image_asset_id"
            case content = "content"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

extension Author.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let name: String
        let excerpt: String
        let profileImageAssetId: String?
        let createdAt: Date
        let updatedAt: Date

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "name"
            case excerpt = "excerpt"
            case profileImageAssetId = "profile_image_asset_id"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

extension Author.Table: DatabaseTableWithDelete {}
