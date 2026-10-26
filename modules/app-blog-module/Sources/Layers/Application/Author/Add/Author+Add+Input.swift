public import BlogModule
public import FeatherApplication
public import WebDomain
public import WebModule

extension Author.Add {
    public struct Input: DTO {
        public let name: String
        public let excerpt: String
        public let content: String
        public let profileImageAssetId: String?
        public let metadata: Metadata.Model.Base

        public init(
            name: String,
            excerpt: String,
            content: String,
            profileImageAssetId: String?,
            metadata: Metadata.Model.Base
        ) {
            self.name = name
            self.excerpt = excerpt
            self.content = content
            self.profileImageAssetId = profileImageAssetId
            self.metadata = metadata
        }
    }
}
