public import FeatherApplication
import NewsDomain
public import NewsModule
public import WebApplication
import WebDomain
public import WebModule

public import struct Foundation.Date

extension Article {
    public enum Detail {}
}

extension Article.Detail {
    public struct Output: DTO {
        public let id: String
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let categoryIds: [String]
        public let metadata: WebModule.Metadata.Detail.Output
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            id: String,
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            categoryIds: [String],
            metadata: WebModule.Metadata.Detail.Output,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.categoryIds = categoryIds
            self.metadata = metadata
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
}
