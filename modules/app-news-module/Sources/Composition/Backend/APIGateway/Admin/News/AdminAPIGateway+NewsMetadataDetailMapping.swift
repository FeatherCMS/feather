import Foundation
import NewsAdminAPI
import WebApplication
import WebDomain

extension AdminAPIGateway {
    func map(
        _ item: MetadataDetail
    ) -> Components.Schemas.NewsMetadataDetailSchema {
        .init(
            id: item.id,
            referenceType: item.referenceType,
            referenceID: item.referenceID,
            slug: item.slug,
            template: item.template,
            publicationDate: item.publicationDate.timeIntervalSince1970,
            expirationDate: item.expirationDate?.timeIntervalSince1970,
            status: item.status.rawValue,
            title: item.title,
            excerpt: item.excerpt,
            imageURL: item.imageURL,
            canonicalURL: item.canonicalURL,
            noIndex: item.noIndex,
            primaryKeyword: item.primaryKeyword,
            cssCodeInjection: item.cssCodeInjection,
            javascriptCodeInjection: item.javascriptCodeInjection,
            structuredDataCodeInjection: item.structuredDataCodeInjection,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }
}
