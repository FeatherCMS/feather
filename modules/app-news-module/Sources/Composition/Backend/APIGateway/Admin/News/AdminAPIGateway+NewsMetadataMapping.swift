import Foundation
import NewsAdminAPI
import WebApplication
import WebDomain
import WebModule

extension Components.Schemas.NewsMetadataInputSchema {
    func pageAddMetadata(template: String) -> Metadata.Input {
        .init(
            slug: slug,
            template: template,
            publicationDate: publicationDate.map(
                Date.init(timeIntervalSince1970:)
            ),
            expirationDate: expirationDate.map(
                Date.init(timeIntervalSince1970:)
            ),
            status: WebModule.Metadata.Model.Status(rawValue: status) ?? .draft,
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

    func pageEditMetadata(template: String) -> Metadata.Input {
        .init(
            slug: slug,
            template: template,
            publicationDate: publicationDate.map(
                Date.init(timeIntervalSince1970:)
            ),
            expirationDate: expirationDate.map(
                Date.init(timeIntervalSince1970:)
            ),
            status: WebModule.Metadata.Model.Status(rawValue: status) ?? .draft,
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
