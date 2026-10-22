public import BlogModule
public import FeatherApplication
public import FeatherDomain
public import WebApplication

extension Tag.Edit {
    public struct Input: DTO {
        public let id: String
        public let title: FieldChange<String>
        public let excerpt: FieldChange<String>
        public let content: FieldChange<String>
        public let imageAssetId: OptionalFieldChange<String>
        public let metadata: PageMetadataInput?

        public init(
            id: String,
            title: FieldChange<String>,
            excerpt: FieldChange<String>,
            content: FieldChange<String>,
            imageAssetId: OptionalFieldChange<String>,
            metadata: PageMetadataInput?
        ) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.metadata = metadata
        }
    }
}
