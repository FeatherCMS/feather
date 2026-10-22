public import FeatherApplication
import NewsDomain
public import NewsModule
public import WebApplication
import WebDomain
public import WebModule

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
        public let metadata: Metadata.Input?

        public init(
            id: String,
            title: String?,
            excerpt: String?,
            content: String?,
            imageAssetId: String??,
            categoryIds: [String]?,
            metadata: Metadata.Input?
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
