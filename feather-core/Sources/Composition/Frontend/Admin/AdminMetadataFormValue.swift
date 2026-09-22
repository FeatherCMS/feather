import FeatherContracts

public struct AdminMetadataFormValue: Sendable, Equatable, Hashable {
    public let slug: String
    public let template: String
    public let publicationDate: String
    public let expirationDate: String
    public let status: String
    public let title: String
    public let excerpt: String
    public let imageUrl: String
    public let canonicalUrl: String
    public let noIndex: Bool
    public let primaryKeyword: String
    public let cssCodeInjection: String
    public let javascriptCodeInjection: String
    public let structuredDataCodeInjection: String

    public init(
        slug: String,
        template: String,
        publicationDate: String,
        expirationDate: String,
        status: String,
        title: String,
        excerpt: String,
        imageUrl: String,
        canonicalUrl: String,
        noIndex: Bool,
        primaryKeyword: String,
        cssCodeInjection: String,
        javascriptCodeInjection: String,
        structuredDataCodeInjection: String
    ) {
        self.slug = slug
        self.template = template
        self.publicationDate = publicationDate
        self.expirationDate = expirationDate
        self.status = status
        self.title = title
        self.excerpt = excerpt
        self.imageUrl = imageUrl
        self.canonicalUrl = canonicalUrl
        self.noIndex = noIndex
        self.primaryKeyword = primaryKeyword
        self.cssCodeInjection = cssCodeInjection
        self.javascriptCodeInjection = javascriptCodeInjection
        self.structuredDataCodeInjection = structuredDataCodeInjection
    }

    public var normalizedSlug: String {
        slug.whitespaceTrimmed
    }

    public var normalizedTemplate: String {
        template.whitespaceTrimmed
    }

    public var normalizedPublicationDate: String {
        publicationDate.whitespaceTrimmed
    }

    public var normalizedExpirationDate: String {
        expirationDate.whitespaceTrimmed
    }

    public var normalizedStatus: String {
        status
            .whitespaceTrimmed
            .lowercased()
    }

    public var normalizedTitle: String {
        title.whitespaceTrimmed
    }

    public var normalizedExcerpt: String {
        excerpt.whitespaceTrimmed
    }

    public var normalizedImageUrl: String {
        imageUrl.whitespaceTrimmed
    }

    public var normalizedCanonicalUrl: String {
        canonicalUrl.whitespaceTrimmed
    }

    public var normalizedPrimaryKeyword: String {
        primaryKeyword.whitespaceTrimmed
    }

    public var normalizedCSSCodeInjection: String {
        cssCodeInjection.whitespaceTrimmed
    }

    public var normalizedJavaScriptCodeInjection: String {
        javascriptCodeInjection.whitespaceTrimmed
    }

    public var normalizedStructuredDataCodeInjection: String {
        structuredDataCodeInjection.whitespaceTrimmed
    }
}
