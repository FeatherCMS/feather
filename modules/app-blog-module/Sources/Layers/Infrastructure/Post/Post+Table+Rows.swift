import BlogModule
import FeatherDBAL

import struct Foundation.Date

extension Post.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let title: String
        let excerpt: String
        let content: String
        let imageAssetId: String?
        let authorIds: String
        let tagIds: String

        enum CodingKeys: String, CodingKey {
            case id
            case title
            case excerpt
            case content
            case imageAssetId = "image_asset_id"
            case authorIds = "author_ids"
            case tagIds = "tag_ids"
        }
    }
}

extension Post.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let title: String
        let excerpt: String
        let content: String
        let imageAssetId: String?
        let authorIds: String
        let tagIds: String

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Post.Table.columns.updatedAt] = .currentTimestamp
        }

        enum CodingKeys: String, CodingKey {
            case title
            case excerpt
            case content
            case imageAssetId = "image_asset_id"
            case authorIds = "author_ids"
            case tagIds = "tag_ids"
        }
    }
}

extension Post.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let title: String
        let excerpt: String
        let content: String
        let imageAssetId: String?
        let authorIds: String
        let tagIds: String
        let createdAt: Date
        let updatedAt: Date
    }
}

extension Post.Table: DatabaseTableWithList {
    struct List: DatabaseTableRowDecodable {
        let id: String
        let title: String
        let excerpt: String
        let imageAssetId: String?
        let createdAt: Date
        let updatedAt: Date
    }
}

extension Post.Table: DatabaseTableWithDelete {}
