public import FeatherApplication
public import WebDomain
public import WebModule

public import struct Foundation.Date

extension Metadata.Edit {
    public struct Output: DTO {
        public let id: String
        public let referenceType: String
        public let referenceID: String
        public let template: String
        public let slug: String
        public let publicationDate: Date
        public let expirationDate: Date?
        public let status: Metadata.Model.Status
        public let title: String?
        public let excerpt: String?
        public let imageURL: String?
        public let canonicalURL: String?
        public let noIndex: Bool
        public let primaryKeyword: String?
        public let cssCodeInjection: String?
        public let javascriptCodeInjection: String?
        public let structuredDataCodeInjection: String?
        public let templateData: String?
        public let createdAt: Date
        public let updatedAt: Date

        public init(
            id: String,
            referenceType: String,
            referenceID: String,
            template: String,
            slug: String,
            publicationDate: Date,
            expirationDate: Date?,
            status: Metadata.Model.Status,
            title: String?,
            excerpt: String?,
            imageURL: String?,
            canonicalURL: String?,
            noIndex: Bool,
            primaryKeyword: String?,
            cssCodeInjection: String?,
            javascriptCodeInjection: String?,
            structuredDataCodeInjection: String?,
            templateData: String? = nil,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.referenceType = referenceType
            self.referenceID = referenceID
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
            self.templateData = templateData
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
}
