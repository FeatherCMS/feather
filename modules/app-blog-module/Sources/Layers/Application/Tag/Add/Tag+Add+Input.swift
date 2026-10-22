public import BlogModule
public import FeatherApplication
public import WebApplication
public import WebDomain

extension Tag.Add {
    public struct Input: DTO {
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let metadata: Page.Add.Input.MetadataInput

        public init(
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            metadata: Page.Add.Input.MetadataInput
        ) {
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.metadata = metadata
        }
    }
}
