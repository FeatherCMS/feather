import FeatherAdmin
import Foundation
import OpenAPIRuntime

public struct WebMetadataFormInput: Codable, Sendable, Equatable, Hashable {

    public let slug: String
    public let publicationDate: String
    public let expirationDate: String
    public let status: String
    public let template: String
    public let title: String
    public let excerpt: String
    public let imageUrl: String
    public let canonicalUrl: String
    public let noIndex: CheckboxFormInput
    public let primaryKeyword: String
    public let cssCodeInjection: String
    public let javascriptCodeInjection: String
    public let structuredDataCodeInjection: String

    enum CodingKeys: String, CodingKey {
        case slug
        case publicationDate
        case expirationDate
        case status
        case template
        case title
        case excerpt
        case imageUrl
        case canonicalUrl
        case noIndex
        case primaryKeyword
        case cssCodeInjection
        case javascriptCodeInjection
        case structuredDataCodeInjection
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.slug = try container.decode(String.self, forKey: .slug)
        self.publicationDate = try container.decode(
            String.self,
            forKey: .publicationDate
        )
        self.expirationDate = try container.decode(
            String.self,
            forKey: .expirationDate
        )
        self.status = try container.decode(String.self, forKey: .status)
        self.template =
            try container.decodeIfPresent(
                String.self,
                forKey: .template
            ) ?? "default"
        self.title = try container.decode(String.self, forKey: .title)
        self.excerpt = try container.decode(String.self, forKey: .excerpt)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.canonicalUrl = try container.decode(
            String.self,
            forKey: .canonicalUrl
        )
        self.noIndex =
            try container.decodeIfPresent(
                CheckboxFormInput.self,
                forKey: .noIndex
            )
            ?? .init(value: false)
        self.primaryKeyword = try container.decode(
            String.self,
            forKey: .primaryKeyword
        )
        self.cssCodeInjection = try container.decode(
            String.self,
            forKey: .cssCodeInjection
        )
        self.javascriptCodeInjection = try container.decode(
            String.self,
            forKey: .javascriptCodeInjection
        )
        self.structuredDataCodeInjection = try container.decode(
            String.self,
            forKey: .structuredDataCodeInjection
        )
    }

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
        status.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedTemplate: String {
        template.trimmingCharacters(in: .whitespacesAndNewlines)
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
