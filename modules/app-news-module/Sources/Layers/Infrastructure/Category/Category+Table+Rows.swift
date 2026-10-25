public import FeatherDBAL
public import NewsModule

public import struct Foundation.Date

extension NewsModule.Category.Table: DatabaseTableWithInsert {
    public struct Insert: DatabaseTableRowEncodable {
        public let id: String
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?

        public init(
            id: String,
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String?
        ) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
        }

        enum CodingKeys: String, CodingKey {
            case id
            case title
            case excerpt
            case content
            case imageAssetId = "image_asset_id"
        }
    }
}

extension NewsModule.Category.Table: DatabaseTableWithUpdate {
    public struct Update: DatabaseTableRowEncodable {
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?

        public init(
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String?
        ) {
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
        }

        public func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Category.Table.columns.updatedAt] = .currentTimestamp
        }

        enum CodingKeys: String, CodingKey {
            case title
            case excerpt
            case content
            case imageAssetId = "image_asset_id"
        }
    }
}

extension NewsModule.Category.Table: DatabaseTableWithDetail {
    public struct Detail: DatabaseTableRowDecodable {
        public let id: String
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let createdAt: Date
        public let updatedAt: Date

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

extension NewsModule.Category.Table: DatabaseTableWithList {
    public struct List: DatabaseTableRowDecodable {
        public let id: String
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let createdAt: Date
        public let updatedAt: Date

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

extension NewsModule.Category.Table: DatabaseTableWithDelete {}
