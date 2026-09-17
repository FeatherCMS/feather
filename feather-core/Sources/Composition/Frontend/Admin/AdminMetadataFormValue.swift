import Foundation

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
        slug.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public var normalizedTemplate: String {
        template.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public var normalizedPublicationDate: String {
        publicationDate.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public var normalizedExpirationDate: String {
        expirationDate.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public var normalizedStatus: String {
        status
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }

    public var normalizedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public var normalizedExcerpt: String {
        excerpt.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public var normalizedImageUrl: String {
        imageUrl.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public var normalizedCanonicalUrl: String {
        canonicalUrl.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public var normalizedPrimaryKeyword: String {
        primaryKeyword.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public var normalizedCSSCodeInjection: String {
        cssCodeInjection.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public var normalizedJavaScriptCodeInjection: String {
        javascriptCodeInjection.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public var normalizedStructuredDataCodeInjection: String {
        structuredDataCodeInjection.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
    }
}
