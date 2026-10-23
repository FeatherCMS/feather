public import FeatherApplication
public import WebDomain
public import WebModule

public import struct Foundation.Date

extension Metadata.Edit {
    public struct Input: DTO {
        public let id: String
        public let template: String?
        public let slug: String?
        public let publicationDate: Date?
        public let expirationDate: Date?
        public let status: Metadata.Model.Status?
        public let title: String?
        public let excerpt: String?
        public let imageURL: String?
        public let canonicalURL: String?
        public let noIndex: Bool?
        public let primaryKeyword: String?
        public let cssCodeInjection: String?
        public let javascriptCodeInjection: String?
        public let structuredDataCodeInjection: String?

        public init(
            id: String,
            template: String? = nil,
            slug: String?,
            publicationDate: Date?,
            expirationDate: Date?,
            status: Metadata.Model.Status?,
            title: String? = nil,
            excerpt: String? = nil,
            imageURL: String? = nil,
            canonicalURL: String?,
            noIndex: Bool? = nil,
            primaryKeyword: String? = nil,
            cssCodeInjection: String?,
            javascriptCodeInjection: String?,
            structuredDataCodeInjection: String? = nil
        ) {
            self.id = id
            self.template = template
            self.slug = slug
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
