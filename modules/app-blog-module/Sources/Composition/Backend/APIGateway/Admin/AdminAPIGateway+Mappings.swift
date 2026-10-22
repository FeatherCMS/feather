import BlogAdminAPI
import BlogApplication
import FeatherApplication
import FeatherModuleKit
import Foundation
import WebAdminAPI
import WebApplication
import WebDomain
import WebModule

extension AdminAPIGateway {
    func timestamp(
        _ date: Date
    ) -> Double {
        date.timeIntervalSince1970
    }

    func timestamp(
        _ date: Date?
    ) -> Double? {
        date.map(timestamp)
    }

    func mapSortDirection(
        _ direction: BlogAdminAPI.Components.Schemas.SortDirection
    ) -> Search.SortDirection {
        switch direction {
        case .asc:
            .asc
        case .desc:
            .desc
        }
    }

    func map(
        _ page: BlogAdminAPI.Components.Schemas.SearchPageSchema?
    ) -> Search.Page {
        let defaults = Search.Page()
        return
            Search.Page(
                size: page?.size ?? defaults.size,
                number: page?.number ?? defaults.number
            )
            .normalized()
    }

    func mapMetadataStatus(
        _ value: String?
    ) -> WebModule.Metadata.Model.Status {
        value.flatMap(WebModule.Metadata.Model.Status.init(rawValue:)) ?? .draft
    }

    func mapBlogMetadata(
        _ metadata: WebAdminAPI.Components.Schemas.WebMetadataCreateSchema
    ) -> Page.Add.Input.MetadataInput {
        .init(
            slug: metadata.slug,
            publicationDate: metadata.publicationDate.map(
                Date.init(timeIntervalSince1970:)
            ),
            expirationDate: metadata.expirationDate.map(
                Date.init(timeIntervalSince1970:)
            ),
            status: mapMetadataStatus(metadata.status),
            title: metadata.title,
            excerpt: metadata.excerpt,
            imageURL: metadata.imageUrl,
            canonicalURL: metadata.canonicalUrl,
            noIndex: metadata.noIndex ?? false,
            primaryKeyword: metadata.primaryKeyword ?? "",
            cssCodeInjection: metadata.cssCodeInjection,
            javascriptCodeInjection: metadata.javascriptCodeInjection,
            structuredDataCodeInjection: metadata.structuredDataCodeInjection
        )
    }

    func defaultBlogMetadata(
        title: String,
        excerpt: String
    ) -> Page.Add.Input.MetadataInput {
        .init(
            slug: title.slugified,
            publicationDate: nil,
            expirationDate: nil,
            status: .draft,
            title: title,
            excerpt: excerpt,
            imageURL: nil,
            canonicalURL: "",
            noIndex: false,
            primaryKeyword: "",
            cssCodeInjection: "",
            javascriptCodeInjection: "",
            structuredDataCodeInjection: ""
        )
    }

    func mergeBlogMetadata(
        _ patch: WebAdminAPI.Components.Schemas.WebMetadataPatchSchema,
        into detail: WebAdminAPI.Components.Schemas.WebMetadataDetailSchema
    ) -> Page.Edit.Input.MetadataInput {
        let publicationDate = (patch.publicationDate ?? detail.publicationDate)
            .map(Date.init(timeIntervalSince1970:))
        let expirationDate = (patch.expirationDate ?? detail.expirationDate)
            .map(Date.init(timeIntervalSince1970:))
        let status = mapMetadataStatus(patch.status)
        let title = patch.title ?? detail.title
        let excerpt = patch.excerpt ?? detail.excerpt
        let imageURL = patch.imageUrl ?? detail.imageUrl
        let canonicalURL = patch.canonicalUrl ?? detail.canonicalUrl
        let noIndex = patch.noIndex ?? detail.noIndex
        let primaryKeyword = patch.primaryKeyword ?? detail.primaryKeyword
        let cssCodeInjection =
            patch.cssCodeInjection
            ?? detail.cssCodeInjection
        let javascriptCodeInjection =
            patch.javascriptCodeInjection
            ?? detail.javascriptCodeInjection
        let structuredDataCodeInjection =
            patch.structuredDataCodeInjection
            ?? detail.structuredDataCodeInjection
        return .init(
            slug: patch.slug ?? detail.slug,
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
            structuredDataCodeInjection: structuredDataCodeInjection
        )
    }

    func map(
        _ detail: WebModule.Metadata.Detail.Output
    ) -> BlogAdminAPI.Components.Schemas.WebMetadataDetailSchema {
        .init(
            id: detail.id,
            referenceType: detail.referenceType,
            referenceId: detail.referenceID,
            slug: detail.slug,
            template: detail.template,
            publicationDate: timestamp(detail.publicationDate),
            expirationDate: timestamp(detail.expirationDate),
            status: detail.status.rawValue,
            title: detail.title,
            excerpt: detail.excerpt,
            imageUrl: detail.imageURL,
            canonicalUrl: detail.canonicalURL,
            noIndex: detail.noIndex,
            primaryKeyword: detail.primaryKeyword ?? "",
            cssCodeInjection: detail.cssCodeInjection,
            javascriptCodeInjection: detail.javascriptCodeInjection,
            structuredDataCodeInjection: detail.structuredDataCodeInjection,
            createdAt: timestamp(detail.createdAt),
            updatedAt: timestamp(detail.updatedAt)
        )
    }
}
