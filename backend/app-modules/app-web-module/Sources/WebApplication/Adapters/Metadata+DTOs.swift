import WebDomain

extension Metadata {

    public var asDetail: MetadataDetail {
        .init(
            referenceType: reference?.type,
            referenceID: reference?.id,
            id: id,
            slug: slug,
            publicationDate: publicationDate,
            expirationDate: expirationDate,
            status: status,
            title: title,
            excerpt: excerpt,
            imageURL: imageURL,
            canonicalURL: canonicalURL,
            noIndex: noIndex,
            primaryKeyword: primaryKeyword,
            cssCodeInjection: cssCodeInjection,
            javascriptCodeInjection: javascriptCodeInjection,
            structuredDataCodeInjection: structuredDataCodeInjection,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
