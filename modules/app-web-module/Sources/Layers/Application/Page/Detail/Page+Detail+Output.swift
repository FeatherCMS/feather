public import FeatherApplication
public import WebDomain

public import struct Foundation.Date

extension Page.Detail {
    public struct Output: DTO {
        public let id: String
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let metadata: Metadata.Detail.Output
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            id: String,
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            metadata: Metadata.Detail.Output,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.metadata = metadata
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
}
