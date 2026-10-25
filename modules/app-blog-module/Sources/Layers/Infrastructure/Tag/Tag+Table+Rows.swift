import BlogModule
import FeatherDBAL

import struct Foundation.Date

extension Tag.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let title: String
        let excerpt: String
        let content: String
        let imageAssetId: String?

        enum CodingKeys: String, CodingKey {
            case id
            case title
            case excerpt
            case content
            case imageAssetId = "image_asset_id"
        }
    }
}

extension Tag.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let title: String
        let excerpt: String
        let content: String
        let imageAssetId: String?

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Tag.Table.columns.updatedAt] = .currentTimestamp
        }

        enum CodingKeys: String, CodingKey {
            case title
            case excerpt
            case content
            case imageAssetId = "image_asset_id"
        }
    }
}

extension Tag.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let title: String
        let excerpt: String
        let content: String
        let imageAssetId: String?
        let createdAt: Date
        let updatedAt: Date

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case title = "title"
            case excerpt = "excerpt"
            case content = "content"
            case imageAssetId = "image_asset_id"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

extension Tag.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let title: String
        let excerpt: String
        let imageAssetId: String?
        let createdAt: Date
        let updatedAt: Date

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case title = "title"
            case excerpt = "excerpt"
            case imageAssetId = "image_asset_id"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

extension Tag.Table: DatabaseTableWithDelete {}
