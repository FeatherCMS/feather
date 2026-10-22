public import FeatherApplication
public import WebApplication
public import WebModule

extension PublicNewsArticle.Detail {
    public struct Output: DTO {
        public let id: String
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let imageURL: String
        public let media: WebApplication.Public.Media?
        public let metadata: WebModule.Metadata.Snapshot
        public let categories: [PublicNewsCategory.Summary.Item]

        public init(
            id: String,
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            imageURL: String,
            media: WebApplication.Public.Media?,
            metadata: WebModule.Metadata.Snapshot,
            categories: [PublicNewsCategory.Summary.Item]
        ) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.imageURL = imageURL
            self.media = media
            self.metadata = metadata
            self.categories = categories
        }
    }
}
