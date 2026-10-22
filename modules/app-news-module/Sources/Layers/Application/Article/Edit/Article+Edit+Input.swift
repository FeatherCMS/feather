public import FeatherApplication
public import NewsModule
public import WebApplication
import NewsDomain
public import WebDomain

extension Article {
    public enum Edit {}
}

extension Article.Edit {
    public struct Input: DTO {
        public let id: String
        public let title: String?
        public let excerpt: String?
        public let content: String?
        public let imageAssetId: String??
        public let categoryIds: [String]?
        public let metadata: Page.Edit.Input.MetadataInput?

        public init(
            id: String,
            title: String?,
            excerpt: String?,
            content: String?,
            imageAssetId: String??,
            categoryIds: [String]?,
            metadata: Page.Edit.Input.MetadataInput?
        ) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.categoryIds = categoryIds
            self.metadata = metadata
        }
    }
}
