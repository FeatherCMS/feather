import Foundation

struct AdminMetadataFormValue: Sendable, Equatable, Hashable {
    let slug: String
    let publicationDate: String
    let expirationDate: String
    let status: String
    let title: String
    let excerpt: String
    let imageUrl: String
    let canonicalUrl: String
    let noIndex: Bool
    let primaryKeyword: String
    let cssCodeInjection: String
    let javascriptCodeInjection: String
    let structuredDataCodeInjection: String

    var normalizedSlug: String {
        slug.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedPublicationDate: String {
        publicationDate.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedExpirationDate: String {
        expirationDate.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedStatus: String {
        status
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }

    var normalizedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedExcerpt: String {
        excerpt.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedImageUrl: String {
        imageUrl.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedCanonicalUrl: String {
        canonicalUrl.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedPrimaryKeyword: String {
        primaryKeyword.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedCSSCodeInjection: String {
        cssCodeInjection.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedJavaScriptCodeInjection: String {
        javascriptCodeInjection.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedStructuredDataCodeInjection: String {
        structuredDataCodeInjection.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
    }
}
