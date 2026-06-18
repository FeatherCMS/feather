import struct Foundation.Date
import Application
import WebDomain

public struct MetadataDetail: DTO {
    public let referenceType: String?
    public let referenceID: String?
    public let id: String
    public let slug: String
    public let publicationDate: Date?
    public let expirationDate: Date?
    public let status: Metadata.Status
    public let title: String?
    public let excerpt: String?
    public let imageURL: String?
    public let canonicalURL: String
    public let noIndex: Bool
    public let primaryKeyword: String
    public let cssCodeInjection: String
    public let javascriptCodeInjection: String
    public let structuredDataCodeInjection: String
    public let createdAt: Date
    public let updatedAt: Date

    public init(
        referenceType: String?,
        referenceID: String?,
        id: String,
        slug: String,
        publicationDate: Date?,
        expirationDate: Date?,
        status: Metadata.Status,
        title: String?,
        excerpt: String?,
        imageURL: String?,
        canonicalURL: String,
        noIndex: Bool,
        primaryKeyword: String,
        cssCodeInjection: String,
        javascriptCodeInjection: String,
        structuredDataCodeInjection: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.referenceType = referenceType
        self.referenceID = referenceID
        self.id = id
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
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
