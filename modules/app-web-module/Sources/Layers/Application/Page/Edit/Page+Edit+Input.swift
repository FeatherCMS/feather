public import FeatherApplication
public import WebModule

extension Page.Edit {
    public struct Input: DTO {
        public let id: String
        public let title: String?
        public let excerpt: String?
        public let content: String?
        public let imageAssetId: String?
        public let metadata: Metadata.Input?

        public init(
            id: String,
            title: String?,
            excerpt: String?,
            content: String?,
            imageAssetId: String?,
            metadata: Metadata.Input?
        ) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.metadata = metadata
        }

    }
}
