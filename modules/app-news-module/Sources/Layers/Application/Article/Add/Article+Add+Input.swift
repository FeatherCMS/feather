public import FeatherApplication
public import NewsModule
public import WebApplication
import NewsDomain
public import WebDomain

extension Article {
    public enum Add {}
}

extension Article.Add {
    public struct Input: DTO {
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let categoryIds: [String]
        public let metadata: Page.Add.Input.MetadataInput

        public init(
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            categoryIds: [String],
            metadata: Page.Add.Input.MetadataInput
        ) {
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.categoryIds = categoryIds
            self.metadata = metadata
        }
    }
}
