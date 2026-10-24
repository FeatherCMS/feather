public import BlogModule
public import FeatherApplication
public import WebApplication
import WebDomain
public import WebModule

extension Tag.Add {
    public struct Input: DTO {
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let metadata: Metadata.Input

        public init(
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            metadata: Metadata.Input
        ) {
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.metadata = metadata
        }
    }
}
