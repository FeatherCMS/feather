import Foundation
import NewsAdminAPI
import WebApplication
import WebDomain

extension Components.Schemas.NewsMetadataInputSchema {
    func pageAddMetadata(template: String) -> Page.Add.Input.MetadataInput {
        .init(
            slug: slug,
            template: template,
            publicationDate: publicationDate.map(
                Date.init(timeIntervalSince1970:)
            ),
            expirationDate: expirationDate.map(
                Date.init(timeIntervalSince1970:)
            ),
            status: Metadata.Model.Status(rawValue: status) ?? .draft,
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

    func pageEditMetadata(template: String) -> Page.Edit.Input.MetadataInput {
        .init(
            slug: slug,
            template: template,
            publicationDate: publicationDate.map(
                Date.init(timeIntervalSince1970:)
            ),
            expirationDate: expirationDate.map(
                Date.init(timeIntervalSince1970:)
            ),
            status: Metadata.Model.Status(rawValue: status) ?? .draft,
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
