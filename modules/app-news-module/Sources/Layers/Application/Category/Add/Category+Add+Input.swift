public import FeatherApplication
public import WebApplication
public import NewsDomain
public import WebDomain

extension Category {
    public enum Add {}
}

extension Category.Add {
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
