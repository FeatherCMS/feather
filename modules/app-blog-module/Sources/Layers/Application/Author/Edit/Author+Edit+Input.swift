public import BlogModule
public import FeatherApplication
public import FeatherDomain
public import WebApplication

extension Author.Edit {
    public struct Input: DTO {
        public let id: String
        public let name: FieldChange<String>
        public let excerpt: FieldChange<String>
        public let content: FieldChange<String>
        public let profileImageAssetId: OptionalFieldChange<String>
        public let metadata: PageMetadataInput?

        public init(
            id: String,
            name: FieldChange<String>,
            excerpt: FieldChange<String>,
            content: FieldChange<String>,
            profileImageAssetId: OptionalFieldChange<String>,
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
