import FeatherApplication
import FeatherDomain
import FeatherModuleKit
import Foundation
import WebAdminAPI
import WebAppAPI
import WebApplication
import WebDomain
import WebModule

extension AdminAPIGateway {
    func mapMetadataStatus(_ value: String?) -> Metadata.Model.Status {
        value.flatMap(Metadata.Model.Status.init(rawValue:)) ?? .draft
    }

    func mapPageMetadata(
        _ metadata: WebAdminAPI.Components.Schemas.MetadataCreateSchema
    ) -> Page.Add.Input.MetadataInput {
        .init(
            slug: metadata.slug,
            template: metadata.template ?? "default",
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

    func defaultPageMetadata(
        title: String,
        excerpt: String
    ) -> Page.Add.Input.MetadataInput {
        .init(
            slug: title.slugified,
            template: "default",
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

    func mergePageMetadata(
        _ patch: WebAdminAPI.Components.Schemas.MetadataPatchSchema,
        into detail: WebAdminAPI.Components.Schemas.MetadataDetailSchema
    ) -> Page.Edit.Input.MetadataInput {
        .init(
            slug: patch.slug ?? detail.slug,
            template: patch.template ?? detail.template,
            publicationDate: (patch.publicationDate ?? detail.publicationDate)
                .map(Date.init(timeIntervalSince1970:)),
            expirationDate: (patch.expirationDate ?? detail.expirationDate)
                .map(Date.init(timeIntervalSince1970:)),
            status: mapMetadataStatus(patch.status ?? detail.status),
            title: patch.title ?? detail.title,
            excerpt: patch.excerpt ?? detail.excerpt,
            imageURL: patch.imageUrl ?? detail.imageUrl,
            canonicalURL: patch.canonicalUrl ?? detail.canonicalUrl,
            noIndex: patch.noIndex ?? detail.noIndex,
            primaryKeyword: patch.primaryKeyword ?? detail.primaryKeyword,
            cssCodeInjection: patch.cssCodeInjection
                ?? detail.cssCodeInjection,
            javascriptCodeInjection: patch.javascriptCodeInjection
                ?? detail.javascriptCodeInjection,
            structuredDataCodeInjection: patch.structuredDataCodeInjection
                ?? detail.structuredDataCodeInjection
        )
    }

    func map(
        _ query: WebAdminAPI.Components.Schemas
            .MetadataQueryItemSearchRequestQuerySchema
    ) -> Metadata.Search.Input.Query {
        .init(
            page: map(query.page),
            sort: query.sort?
                .compactMap { sort in
                    guard
                        let field = Metadata.Search.Input.Query.Sort.Field(
                            rawValue: sort.field.rawValue
                        )
                    else { return nil }
                    return .init(
                        field: field,
                        direction: mapSortDirection(sort.direction)
                    )
                } ?? [],
            search: query.filters.search,
            referenceType: query.filters.referenceType
        )
    }

    func map(_ detail: Metadata.Detail.Output)
        -> WebAdminAPI.Components.Schemas.MetadataDetailSchema
    {
        .init(
            id: detail.id,
            referenceType: detail.referenceType,
            referenceId: detail.referenceID,
            slug: detail.slug,
            template: detail.template,
            publicationDate: detail.publicationDate.timeIntervalSince1970,
            expirationDate: detail.expirationDate?.timeIntervalSince1970,
            status: detail.status.rawValue,
            availability: .init(
                rawValue: detail.availability(at: .now).rawValue
            )
                ?? .draft,
            title: detail.title,
            excerpt: detail.excerpt,
            imageUrl: detail.imageURL,
            canonicalUrl: detail.canonicalURL,
            noIndex: detail.noIndex,
            primaryKeyword: detail.primaryKeyword ?? "",
            cssCodeInjection: detail.cssCodeInjection,
            javascriptCodeInjection: detail.javascriptCodeInjection,
            structuredDataCodeInjection: detail.structuredDataCodeInjection,
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }

    func map(_ item: Metadata.List.Output.Item)
        -> WebAdminAPI.Components.Schemas.MetadataListItemSchema
    {
        .init(
            id: item.id,
            referenceType: item.referenceType,
            referenceId: item.referenceID,
            slug: item.slug,
            publicationDate: item.publicationDate.timeIntervalSince1970,
            expirationDate: item.expirationDate?.timeIntervalSince1970,
            status: item.status.rawValue,
            availability: .init(rawValue: item.availability(at: .now).rawValue)
                ?? .draft,
            title: item.title,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    func mapQuery(_ item: Metadata.Search.Output.Item)
        -> WebAdminAPI.Components.Schemas.MetadataQueryItemSchema
    {
        .init(
            id: item.id,
            referenceType: item.referenceType,
            referenceId: item.referenceID,
            slug: item.slug,
            publicationDate: item.publicationDate.timeIntervalSince1970,
            expirationDate: item.expirationDate?.timeIntervalSince1970,
            status: item.status.rawValue,
            availability: .init(rawValue: item.availability(at: .now).rawValue)
                ?? .draft,
            title: item.title,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    func mapResolveMetadata(
        _ item: Metadata.List.Output.Item,
        at date: Date
    ) -> WebAdminAPI.Components.Schemas.MetadataResolveItemSchema {
        .init(
            referenceId: item.referenceID,
            slug: item.slug,
            publicationDate: item.publicationDate.timeIntervalSince1970,
            expirationDate: item.expirationDate?.timeIntervalSince1970,
            status: item.status.rawValue,
            availability: .init(rawValue: item.availability(at: date).rawValue)
                ?? .draft
        )
    }
}
