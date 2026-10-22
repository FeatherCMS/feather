import FeatherModuleKit
import WebDomain

extension Page.Edit.Input.MetadataInput {
    func asMetadataBase() -> Metadata.Model.Base {
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
