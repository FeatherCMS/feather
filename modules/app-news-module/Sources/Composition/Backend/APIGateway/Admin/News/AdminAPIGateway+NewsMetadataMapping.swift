import Foundation
import NewsAdminAPI
import WebApplication
import WebDomain

extension Components.Schemas.NewsMetadataInputSchema {
    func pageMetadata(template: String) -> PageMetadataInput {
        .init(
            slug: slug,
            template: template,
            publicationDate: publicationDate.map(
                Date.init(timeIntervalSince1970:)
            ),
            expirationDate: expirationDate.map(
                Date.init(timeIntervalSince1970:)
            ),
            status: Metadata.Status(rawValue: status) ?? .draft,
            title: title,
            excerpt: excerpt,
            imageURL: imageURL,
            canonicalURL: canonicalURL,
            noIndex: noIndex ?? false,
            primaryKeyword: primaryKeyword ?? "",
            cssCodeInjection: cssCodeInjection,
            javascriptCodeInjection: javascriptCodeInjection,
            structuredDataCodeInjection: structuredDataCodeInjection
        )
    }
}
