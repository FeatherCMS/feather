import FeatherAdmin
import Foundation
import OpenAPIRuntime
import WebAppAPI

public struct AppPublicMetadataModel: Sendable {
    public let slug: String
    public let title: String
    public let excerpt: String
    public let imageURL: String
    public let canonicalURL: String?
    public let noIndex: Bool
    public let cssCodeInjection: String?
    public let javascriptCodeInjection: String?
    public let structuredDataCodeInjection: String?
    public let publicationDateText: String?

    public init(
        slug: String,
        title: String,
        excerpt: String,
        imageURL: String,
        canonicalURL: String?,
        noIndex: Bool,
        cssCodeInjection: String?,
        javascriptCodeInjection: String?,
        structuredDataCodeInjection: String?,
        publicationDateText: String?
    ) {
        self.slug = slug
        self.title = title
        self.excerpt = excerpt
        self.imageURL = imageURL
        self.canonicalURL = canonicalURL
        self.noIndex = noIndex
        self.cssCodeInjection = cssCodeInjection
        self.javascriptCodeInjection = javascriptCodeInjection
        self.structuredDataCodeInjection = structuredDataCodeInjection
        self.publicationDateText = publicationDateText
    }

    public func seoTitle(
        fallback: String
    ) -> String {
        title.isEmpty ? fallback : title
    }

    public func seoDescription(
        fallback: String
    ) -> String {
        excerpt.isEmpty ? fallback : excerpt
    }

    public func seoImageURL(
        fallback: String
    ) -> String {
        imageURL.isEmpty ? fallback : imageURL
    }
}

extension AppPublicMetadataModel {
    public init(schema: Components.Schemas.WebMetadataContentSchema) {
        self.slug = schema.slug
        self.title = schema.title
        self.excerpt = schema.excerpt
        self.imageURL = schema.imageURL
        self.canonicalURL = schema.canonicalURL
        self.noIndex = schema.noIndex
        self.cssCodeInjection = schema.cssCodeInjection
        self.javascriptCodeInjection = schema.javascriptCodeInjection
        self.structuredDataCodeInjection = schema.structuredDataCodeInjection
        if let publicationDate = schema.publicationDate {
            self.publicationDateText =
                DateFormatting.formatUnixTimestamp(publicationDate)
        }
        else {
            self.publicationDateText = nil
        }
    }
}
