public import FeatherDBAL
public import struct Foundation.Date
public import NewsModule

extension Article.Table: DatabaseTableWithInsert {
    public struct Insert: DatabaseTableRowEncodable {
        public let id: String
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?

        public init(id: String, title: String, excerpt: String, content: String, imageAssetId: String?) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
        }
    }
}

extension Article.Table: DatabaseTableWithUpdate {
    public struct Update: DatabaseTableRowEncodable {
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?

        public init(title: String, excerpt: String, content: String, imageAssetId: String?) {
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
        }

        public func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Article.Table.columns.updatedAt] = .currentTimestamp
        }
    }
}

extension Article.Table: DatabaseTableWithDetail {
    public struct Detail: DatabaseTableRowDecodable {
        public let id: String
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let createdAt: Date
        public let updatedAt: Date
    }
}

extension Article.Table: DatabaseTableWithList {
    public struct List: DatabaseTableRowDecodable {
        public let id: String
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let createdAt: Date
        public let updatedAt: Date
    }
}

extension Article.Table: DatabaseTableWithDelete {}
