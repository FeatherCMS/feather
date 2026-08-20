import struct Foundation.Date

public struct WebPageMetadataDefinition: Sendable, Equatable {
    public let template: String
    public let slug: String
    public let publicationDate: Date
    public let expirationDate: Date?
    public let status: WebPageMetadataStatus
    public let title: String?
    public let excerpt: String?
    public let imageURL: String?
    public let canonicalURL: String?
    public let noIndex: Bool
    public let primaryKeyword: String?
    public let cssCodeInjection: String?
    public let javascriptCodeInjection: String?
    public let structuredDataCodeInjection: String?

    public init(
        template: String,
        slug: String,
        publicationDate: Date = .init(),
        expirationDate: Date? = nil,
        status: WebPageMetadataStatus = .draft,
        title: String? = nil,
        excerpt: String? = nil,
        imageURL: String? = nil,
        canonicalURL: String? = nil,
        noIndex: Bool = false,
        primaryKeyword: String? = nil,
        cssCodeInjection: String? = nil,
        javascriptCodeInjection: String? = nil,
        structuredDataCodeInjection: String? = nil
    ) {
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
