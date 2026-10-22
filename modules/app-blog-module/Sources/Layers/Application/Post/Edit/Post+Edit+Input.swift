public import BlogModule
public import FeatherApplication
public import WebApplication

extension Post.Edit {
    public struct Input: DTO {
        public let id: String
        public let title: String?
        public let excerpt: String?
        public let content: String?
        public let imageAssetId: String??
        public let authorIds: [String]?
        public let tagIds: [String]?
        public let metadata: PageMetadataInput?

        public init(
            id: String,
            title: String?,
            excerpt: String?,
            content: String?,
            imageAssetId: String??,
            authorIds: [String]?,
            tagIds: [String]?,
            metadata: PageMetadataInput?
        ) {
            self.id = id
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
