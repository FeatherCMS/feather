public import BlogModule
public import FeatherApplication
public import WebApplication

extension Author.Add {
    public struct Input: DTO {
        public let name: String
        public let excerpt: String
        public let content: String
        public let profileImageAssetId: String?
        public let metadata: PageMetadataInput

        public init(
            name: String,
            excerpt: String,
            content: String,
            profileImageAssetId: String?,
            metadata: PageMetadataInput
        ) {
            self.name = name
            self.excerpt = excerpt
            self.content = content
            self.profileImageAssetId = profileImageAssetId
            self.metadata = metadata
        }
    }
}
