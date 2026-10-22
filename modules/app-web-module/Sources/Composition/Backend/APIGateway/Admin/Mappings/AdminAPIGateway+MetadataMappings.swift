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
    ) -> Metadata.Input {
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
    ) -> Metadata.Input {
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
    ) -> Metadata.Input {
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
        mapMetadata(
            id: detail.id,
            referenceType: detail.referenceType,
            referenceID: detail.referenceID,
            slug: detail.slug,
            template: detail.template,
            publicationDate: detail.publicationDate,
            expirationDate: detail.expirationDate,
            status: detail.status,
            availability: .init(
                status: detail.status,
                publicationDate: detail.publicationDate,
                expirationDate: detail.expirationDate,
                at: .now
            ),
            title: detail.title,
            excerpt: detail.excerpt,
            imageURL: detail.imageURL,
            canonicalURL: detail.canonicalURL,
            noIndex: detail.noIndex,
            primaryKeyword: detail.primaryKeyword,
            cssCodeInjection: detail.cssCodeInjection,
            javascriptCodeInjection: detail.javascriptCodeInjection,
            structuredDataCodeInjection: detail.structuredDataCodeInjection,
            createdAt: detail.createdAt,
            updatedAt: detail.updatedAt
        )
    }

    func map(_ detail: Metadata.Snapshot)
        -> WebAdminAPI.Components.Schemas.MetadataDetailSchema
    {
        mapMetadata(
            id: detail.id,
            referenceType: detail.referenceType,
            referenceID: detail.referenceID,
            slug: detail.slug,
            template: detail.template,
            publicationDate: detail.publicationDate,
            expirationDate: detail.expirationDate,
            status: detail.status,
            availability: detail.availability(at: .now),
            title: detail.title,
            excerpt: detail.excerpt,
            imageURL: detail.imageURL,
            canonicalURL: detail.canonicalURL,
            noIndex: detail.noIndex,
            primaryKeyword: detail.primaryKeyword,
            cssCodeInjection: detail.cssCodeInjection,
            javascriptCodeInjection: detail.javascriptCodeInjection,
            structuredDataCodeInjection: detail.structuredDataCodeInjection,
            createdAt: detail.createdAt,
            updatedAt: detail.updatedAt
        )
    }

    func map(_ output: Metadata.Add.Output)
        -> WebAdminAPI.Components.Schemas.MetadataDetailSchema
    {
        mapMetadata(
            id: output.id,
            referenceType: output.referenceType,
            referenceID: output.referenceID,
            slug: output.slug,
            template: output.template,
            publicationDate: output.publicationDate,
            expirationDate: output.expirationDate,
            status: output.status,
            availability: .init(
                status: output.status,
                publicationDate: output.publicationDate,
                expirationDate: output.expirationDate,
                at: .now
            ),
            title: output.title,
            excerpt: output.excerpt,
            imageURL: output.imageURL,
            canonicalURL: output.canonicalURL,
            noIndex: output.noIndex,
            primaryKeyword: output.primaryKeyword,
            cssCodeInjection: output.cssCodeInjection,
            javascriptCodeInjection: output.javascriptCodeInjection,
            structuredDataCodeInjection: output.structuredDataCodeInjection,
            createdAt: output.createdAt,
            updatedAt: output.updatedAt
        )
    }

    func map(_ output: Metadata.Edit.Output)
        -> WebAdminAPI.Components.Schemas.MetadataDetailSchema
    {
        mapMetadata(
            id: output.id,
            referenceType: output.referenceType,
            referenceID: output.referenceID,
            slug: output.slug,
            template: output.template,
            publicationDate: output.publicationDate,
            expirationDate: output.expirationDate,
            status: output.status,
            availability: .init(
                status: output.status,
                publicationDate: output.publicationDate,
                expirationDate: output.expirationDate,
                at: .now
            ),
            title: output.title,
            excerpt: output.excerpt,
            imageURL: output.imageURL,
            canonicalURL: output.canonicalURL,
            noIndex: output.noIndex,
            primaryKeyword: output.primaryKeyword,
            cssCodeInjection: output.cssCodeInjection,
            javascriptCodeInjection: output.javascriptCodeInjection,
            structuredDataCodeInjection: output.structuredDataCodeInjection,
            createdAt: output.createdAt,
            updatedAt: output.updatedAt
        )
    }

    private func mapMetadata(
        id: String,
        referenceType: String,
        referenceID: String,
        slug: String,
        template: String,
        publicationDate: Date,
        expirationDate: Date?,
        status: Metadata.Model.Status,
        availability: Metadata.Model.Availability,
        title: String?,
        excerpt: String?,
        imageURL: String?,
        canonicalURL: String?,
        noIndex: Bool,
        primaryKeyword: String?,
        cssCodeInjection: String?,
        javascriptCodeInjection: String?,
        structuredDataCodeInjection: String?,
        createdAt: Date,
        updatedAt: Date
    ) -> WebAdminAPI.Components.Schemas.MetadataDetailSchema {
        .init(
            id: id,
            referenceType: referenceType,
            referenceId: referenceID,
            slug: slug,
            template: template,
            publicationDate: publicationDate.timeIntervalSince1970,
            expirationDate: expirationDate?.timeIntervalSince1970,
            status: status.rawValue,
            availability: .init(
                rawValue: availability.rawValue
            )
                ?? .draft,
            title: title,
            excerpt: excerpt,
            imageUrl: imageURL,
            canonicalUrl: canonicalURL,
            noIndex: noIndex,
            primaryKeyword: primaryKeyword ?? "",
            cssCodeInjection: cssCodeInjection,
            javascriptCodeInjection: javascriptCodeInjection,
            structuredDataCodeInjection: structuredDataCodeInjection,
            createdAt: createdAt.timeIntervalSince1970,
            updatedAt: updatedAt.timeIntervalSince1970
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
