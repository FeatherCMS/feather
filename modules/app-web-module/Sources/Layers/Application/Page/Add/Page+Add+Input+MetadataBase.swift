import FeatherModuleKit
import Foundation
public import WebDomain
public import WebModule

extension Page.Add.Input.MetadataInput {
    public func asMetadataBase(
        template: String? = nil,
        slug: String? = nil
    ) -> Metadata.Model.Base {
        .init(
            template: template ?? self.template,
            slug: slug ?? self.slug,
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
