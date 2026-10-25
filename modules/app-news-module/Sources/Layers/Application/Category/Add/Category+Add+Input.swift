public import FeatherApplication
import NewsDomain
public import NewsModule
public import WebApplication
import WebDomain
public import WebModule

extension Category {
    public enum Add {}
}

extension Category.Add {
    public struct Input: DTO {
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let metadata: Metadata.Model.Base

        public init(
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            metadata: Metadata.Model.Base
        ) {
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.metadata = metadata
        }
    }
}
