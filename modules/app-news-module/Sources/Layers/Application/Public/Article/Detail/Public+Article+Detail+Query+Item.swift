public import WebApplication
public import WebModule

extension Public.Article.Detail.Query {
    public struct Item: Sendable {
        public let id: String
        public let title: String
        public let excerpt: String
        public let imageAssetId: String?
        public let metadata: WebModule.Metadata.Snapshot

        public init(
            id: String,
            title: String,
            excerpt: String,
            imageAssetId: String?,
            metadata: WebModule.Metadata.Snapshot
        ) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.imageAssetId = imageAssetId
            self.metadata = metadata
        }
    }
}
