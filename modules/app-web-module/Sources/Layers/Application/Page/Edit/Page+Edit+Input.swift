public import FeatherApplication
public import WebDomain

public import struct Foundation.Date

extension Page.Edit {
    public struct Input: DTO {
        public let id: String
        public let title: String?
        public let excerpt: String?
        public let content: String?
        public let imageAssetId: String?
        public let metadata: MetadataInput?

        public init(
            id: String,
            title: String?,
            excerpt: String?,
            content: String?,
            imageAssetId: String?,
            metadata: MetadataInput?
        ) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.metadata = metadata
        }

        public struct MetadataInput: DTO {
            public let template: String
            public let slug: String
            public let publicationDate: Date?
            public let expirationDate: Date?
            public let status: Metadata.Model.Status
            public let title: String?
            public let excerpt: String?
            public let imageURL: String?
            public let canonicalURL: String?
            public let noIndex: Bool
            public let primaryKeyword: String
            public let cssCodeInjection: String?
            public let javascriptCodeInjection: String?
            public let structuredDataCodeInjection: String?

            public init(
                slug: String,
                template: String = "default",
                publicationDate: Date?,
                expirationDate: Date?,
                status: Metadata.Model.Status,
                title: String?,
                excerpt: String?,
                imageURL: String?,
                canonicalURL: String?,
                noIndex: Bool,
                primaryKeyword: String,
                cssCodeInjection: String?,
                javascriptCodeInjection: String?,
                structuredDataCodeInjection: String?
            ) {
                self.slug = slug
                self.template = template
                self.publicationDate = publicationDate
                self.expirationDate = expirationDate
                self.status = status
                self.title = title
                self.excerpt = excerpt
                self.imageURL = imageURL
                self.canonicalURL = canonicalURL
                self.noIndex = noIndex
                self.primaryKeyword = primaryKeyword
                self.cssCodeInjection = cssCodeInjection
                self.javascriptCodeInjection = javascriptCodeInjection
                self.structuredDataCodeInjection = structuredDataCodeInjection
            }
        }
    }
}
