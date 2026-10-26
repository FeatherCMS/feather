public import FeatherApplication
import NewsDomain
public import NewsModule
public import WebDomain
public import WebModule

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
        public let metadata: Metadata.Model.Base

        public init(
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            categoryIds: [String],
            metadata: Metadata.Model.Base
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
