public import WebApplication
public import WebModule

extension Public.Post.Summary {
    public struct Item: Sendable {
        public let id: String
        public let title: String
        public let excerpt: String
        public let imageAssetId: String?
        public let imageURL: String
        public let media: WebApplication.Public.Media?
        public let metadata: WebModule.Metadata.Snapshot
        public let authors: [Public.Author.Summary.Item]
        public let tags: [Public.Tag.Summary.Item]

        public init(
            id: String,
            title: String,
            excerpt: String,
            imageAssetId: String?,
            imageURL: String,
            media: WebApplication.Public.Media?,
            metadata: WebModule.Metadata.Snapshot,
            authors: [Public.Author.Summary.Item] = [],
            tags: [Public.Tag.Summary.Item] = []
        ) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.imageAssetId = imageAssetId
            self.imageURL = imageURL
            self.media = media
            self.metadata = metadata
            self.authors = authors
            self.tags = tags
        }
    }
}
