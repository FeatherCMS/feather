public import BlogModule
public import FeatherApplication
public import WebApplication

extension Author.Edit {
    public struct Input: DTO {
        public let id: String
        public let name: String?
        public let excerpt: String?
        public let content: String?
        public let profileImageAssetId: String?
        public let metadata: PageMetadataInput?

        public init(
            id: String,
            name: String?,
            excerpt: String?,
            content: String?,
            profileImageAssetId: String?,
            metadata: PageMetadataInput?
        ) {
            self.id = id
            self.name = name
            self.excerpt = excerpt
            self.content = content
            self.profileImageAssetId = profileImageAssetId
            self.metadata = metadata
        }
    }
}
