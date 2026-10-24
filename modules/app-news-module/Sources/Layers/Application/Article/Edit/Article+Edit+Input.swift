public import FeatherApplication
public import FeatherDomain
import NewsDomain
public import NewsModule
public import WebApplication
import WebDomain
public import WebModule

extension Article {
    public enum Edit {}
}

extension Article.Edit {
    public struct Input: DTO {
        public let id: String
        public let title: FieldChange<String>
        public let excerpt: FieldChange<String>
        public let content: FieldChange<String>
        public let imageAssetId: OptionalFieldChange<String>
        public let categoryIds: FieldChange<[String]>
        public let metadata: FieldChange<Metadata.Input>

        public init(
            id: String,
            title: FieldChange<String> = .unchanged,
            excerpt: FieldChange<String> = .unchanged,
            content: FieldChange<String> = .unchanged,
            imageAssetId: OptionalFieldChange<String> = .unchanged,
            categoryIds: FieldChange<[String]> = .unchanged,
            metadata: FieldChange<Metadata.Input> = .unchanged
        ) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.categoryIds = categoryIds
            self.metadata = metadata
        }
    }
}
