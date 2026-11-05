public import FeatherApplication
public import WebModule

extension Public.Page.Detail {
    public struct Output: DTO {
        public let id: String
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let imageURL: String
        public let media: Public.Media?
        public let metadata: Metadata.Snapshot

        public init(
            id: String,
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            imageURL: String,
            media: Public.Media?,
            metadata: Metadata.Snapshot
        ) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.imageURL = imageURL
            self.media = media
            self.metadata = metadata
        }

    }
}
