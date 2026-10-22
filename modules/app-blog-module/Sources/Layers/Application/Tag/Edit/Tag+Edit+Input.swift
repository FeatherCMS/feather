public import BlogModule
public import FeatherApplication
public import FeatherDomain
public import WebApplication
public import WebDomain

extension Tag.Edit {
    public struct Input: DTO {
        public let id: String
        public let title: FieldChange<String>
        public let excerpt: FieldChange<String>
        public let content: FieldChange<String>
        public let imageAssetId: OptionalFieldChange<String>
        public let metadata: Page.Edit.Input.MetadataInput?

        public init(
            id: String,
            title: FieldChange<String>,
            excerpt: FieldChange<String>,
            content: FieldChange<String>,
            imageAssetId: OptionalFieldChange<String>,
            metadata: Page.Edit.Input.MetadataInput?
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
