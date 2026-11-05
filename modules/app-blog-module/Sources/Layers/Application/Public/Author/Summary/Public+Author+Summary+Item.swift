public import WebApplication
public import WebModule

extension Public.Author.Summary {
    public struct Item: Sendable {
        public let id: String
        public let name: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let imageURL: String
        public let media: WebApplication.Public.Media?
        public let metadata: WebModule.Metadata.Snapshot

        public init(
            id: String,
            name: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            imageURL: String,
            media: WebApplication.Public.Media?,
            metadata: WebModule.Metadata.Snapshot
        ) {
            self.id = id
            self.name = name
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.imageURL = imageURL
            self.media = media
            self.metadata = metadata
        }
    }
}
