public import FeatherApplication
public import FeatherModuleKit
public import WebDomain

extension Public.Page.Detail {
    public struct Output: DTO {
        public let id: String
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let imageURL: String
        public let media: Media?
        public let metadata: Metadata.Detail.Output

        public init(
            id: String,
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            imageURL: String,
            media: Media?,
            metadata: Metadata.Detail.Output
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

        public struct Media: DTO {
            public let assetId: String
            public let originalURL: String
            public let defaultURL: String
            public let variants: [MediaURLVariant]

            public init(
                assetId: String,
                originalURL: String,
                defaultURL: String,
                variants: [MediaURLVariant]
            ) {
                self.assetId = assetId
                self.originalURL = originalURL
                self.defaultURL = defaultURL
                self.variants = variants
            }
        }
    }
}
