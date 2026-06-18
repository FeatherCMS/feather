import AppOpenAPI
import Foundation

struct AppPublicMetadataModel: Sendable {
    let slug: String
    let title: String
    let excerpt: String
    let imageURL: String
    let canonicalURL: String
    let noIndex: Bool
    let cssCodeInjection: String
    let javascriptCodeInjection: String
    let structuredDataCodeInjection: String
    let publicationDateText: String?

    func seoTitle(
        fallback: String
    ) -> String {
        title.isEmpty ? fallback : title
    }

    func seoDescription(
        fallback: String
    ) -> String {
        excerpt.isEmpty ? fallback : excerpt
    }

    func seoImageURL(
        fallback: String
    ) -> String {
        imageURL.isEmpty ? fallback : imageURL
    }
}

extension AppPublicMetadataModel {
    init(schema: Components.Schemas.WebMetadataContentSchema) {
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
