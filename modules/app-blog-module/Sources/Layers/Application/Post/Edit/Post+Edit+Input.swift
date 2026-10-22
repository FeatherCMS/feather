public import BlogModule
public import FeatherApplication
public import FeatherDomain
public import WebApplication
import WebDomain
public import WebModule

extension Post.Edit {
    public struct Input: DTO {
        public let id: String
        public let title: FieldChange<String>
        public let excerpt: FieldChange<String>
        public let content: FieldChange<String>
        public let imageAssetId: OptionalFieldChange<String>
        public let authorIds: FieldChange<[String]>
        public let tagIds: FieldChange<[String]>
        public let metadata: Page.Edit.Input.MetadataInput?

        public init(
            id: String,
            title: FieldChange<String>,
            excerpt: FieldChange<String>,
            content: FieldChange<String>,
            imageAssetId: OptionalFieldChange<String>,
            authorIds: FieldChange<[String]>,
            tagIds: FieldChange<[String]>,
            metadata: Page.Edit.Input.MetadataInput?
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
