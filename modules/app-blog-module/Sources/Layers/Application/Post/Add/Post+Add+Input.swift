public import BlogModule
public import FeatherApplication
public import WebApplication
import WebDomain
public import WebModule

extension Post.Add {
    public struct Input: DTO {
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let authorIds: [String]
        public let tagIds: [String]
        public let metadata: Metadata.Model.Base

        public init(
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            authorIds: [String],
            tagIds: [String],
            metadata: Metadata.Model.Base
        ) {
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.authorIds = authorIds
            self.tagIds = tagIds
            self.metadata = metadata
        }
    }
}
