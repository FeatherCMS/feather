import FeatherContracts
import FeatherDomain
import Foundation
import WebDomain

extension PageMetadataInput {
    public func asMetadataBase(
        template: String,
        slug: String
    ) -> Metadata.Base {
        .init(
            template: template,
            slug: slug,
            publicationDate: publicationDate ?? .init(),
            expirationDate: expirationDate,
            status: status,
            title: title,
            excerpt: excerpt,
            imageURL: imageURL,
            canonicalURL: canonicalURL,
            noIndex: noIndex,
            primaryKeyword: primaryKeyword.emptyToNil,
            cssCodeInjection: cssCodeInjection,
            javascriptCodeInjection: javascriptCodeInjection,
            structuredDataCodeInjection: structuredDataCodeInjection
        )
    }
}
