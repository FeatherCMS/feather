public import FeatherApplication
public import FeatherDomain
public import WebDomain
public import WebModule

public import struct Foundation.Date

extension Page.Edit {
    public struct Input: DTO {
        public let id: String
        public let title: FieldChange<String>
        public let excerpt: FieldChange<String>
        public let content: FieldChange<String>
        public let imageAssetId: OptionalFieldChange<String>
        public let metadata: Metadata.Model.Base?
        public let metadataPublicationDate: FieldChange<Date>

        public init(
            id: String,
            title: FieldChange<String> = .unchanged,
            excerpt: FieldChange<String> = .unchanged,
            content: FieldChange<String> = .unchanged,
            imageAssetId: OptionalFieldChange<String> = .unchanged,
            metadata: Metadata.Model.Base?,
            metadataPublicationDate: FieldChange<Date> = .unchanged
        ) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.metadata = metadata
            self.metadataPublicationDate = metadataPublicationDate
        }

    }
}
