import Foundation

extension PublicNewsArticle {
    public struct Item: Sendable {
        public let id: String
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let createdAt: Date
        public let updatedAt: Date

        public init(
            id: String,
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
}
