import FeatherApplication
import FeatherContracts
import FeatherDomain
import Foundation
import WebAdminAPI
import WebAppAPI
import WebApplication
import WebDomain

extension UseCases {
    func publicMedia(assetId: String?) async -> PublicContentMedia? {
        nil
    }

    func mapPublicMedia(
        _ media: PublicContentMedia?
    ) -> WebAppAPI.Components.Schemas.MediaAssetSchema? {
        guard let media else { return nil }
        return .init(
            assetId: media.assetId,
            originalURL: media.originalURL,
            defaultURL: media.defaultURL,
            variants: media.variants.map {
                .init(
                    id: $0.id,
                    url: $0.url,
                    _type: $0.type,
                    width: $0.width.map(Int64.init),
                    height: $0.height.map(Int64.init)
                )
            }
        )
    }

    func mapPublicMenu(
        _ menu: PublicMenu
    ) -> WebAppAPI.Components.Schemas.WebMenuSchema {
        .init(
            id: menu.id,
            key: menu.key,
            name: menu.name,
            items: menu.items.map {
                .init(
                    id: $0.id,
                    label: $0.label,
                    url: $0.url,
                    priority: $0.priority,
                    isBlank: $0.isBlank
                )
            }
        )
    }

    func mapPublicMetadata(
        _ metadata: MetadataDetail,
        title: String,
        excerpt: String,
        imageURL: String
    ) -> WebAppAPI.Components.Schemas.WebMetadataContentSchema {
        .init(
            slug: metadata.slug,
            template: metadata.template,
            publicationDate: timestamp(metadata.publicationDate),
            expirationDate: timestamp(metadata.expirationDate),
            status: metadata.status.rawValue,
            title: title,
            excerpt: excerpt,
            imageURL: imageURL,
            canonicalURL: metadata.canonicalURL,
            noIndex: metadata.noIndex,
            cssCodeInjection: metadata.cssCodeInjection,
            javascriptCodeInjection: metadata.javascriptCodeInjection,
            structuredDataCodeInjection: metadata.structuredDataCodeInjection
        )
    }

    func timestamp(_ date: Date?) -> Double? { date?.timeIntervalSince1970 }

    func mapMetadataStatus(_ value: String?) -> Metadata.Status {
        value.flatMap(Metadata.Status.init(rawValue:)) ?? .draft
    }

    func mapPageMetadata(
        _ metadata: WebAdminAPI.Components.Schemas.WebMetadataCreateSchema
    ) -> PageMetadataInput {
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
    ) -> PageMetadataInput {
        .init(
            slug: title,
            template: "default",
            publicationDate: nil,
            expirationDate: nil,
            status: .published,
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
        _ patch: WebAdminAPI.Components.Schemas.WebMetadataPatchSchema,
        into detail: WebAdminAPI.Components.Schemas.WebMetadataDetailSchema
    ) -> PageMetadataInput {
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

    func map(_ page: WebAdminAPI.Components.Schemas.SearchPageSchema)
        -> Search.Page
    {
        .init(size: page.size, number: page.number)
    }

    func mapSortDirection(
        _ direction: WebAdminAPI.Components.Schemas.SortDirection
    ) -> Search.SortDirection {
        direction == .asc ? .asc : .desc
    }

    func map(
        _ query: WebAdminAPI.Components.Schemas
            .WebMetadataListItemSearchQuerySchema
    ) -> MetadataList.Query {
        .init(
            page: map(query.page),
            sort: [],
            search: query.filters.search,
            referenceType: query.filters.referenceType
        )
    }

    func map(_ detail: MetadataDetail)
        -> WebAdminAPI.Components.Schemas.WebMetadataDetailSchema
    {
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
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }

    func map(_ item: MetadataList.Item)
        -> WebAdminAPI.Components.Schemas.WebMetadataListItemSchema
    {
        .init(
            id: item.id,
            referenceType: item.referenceType,
            referenceId: item.referenceID,
            slug: item.slug,
            publicationDate: timestamp(item.publicationDate),
            expirationDate: timestamp(item.expirationDate),
            status: item.status.rawValue,
            title: item.title,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    func map(
        _ query: WebAdminAPI.Components.Schemas.WebPageListItemSearchQuerySchema
    ) -> PageList.Query {
        .init(page: map(query.page), sort: [], search: query.filters.search)
    }

    func map(_ detail: PageDetail)
        -> WebAdminAPI.Components.Schemas.WebPageDetailSchema
    {
        .init(
            id: detail.id,
            title: detail.title,
            excerpt: detail.excerpt,
            content: detail.content,
            imageAssetId: detail.imageAssetId,
            metadata: map(detail.metadata),
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }

    func map(_ item: PageList.Item)
        -> WebAdminAPI.Components.Schemas.WebPageListItemSchema
    {
        .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            imageAssetId: item.imageAssetId,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    func map(
        _ query: WebAdminAPI.Components.Schemas.WebMenuListItemSearchQuerySchema
    ) -> MenuList.Query {
        .init(page: map(query.page), sort: [], search: query.filters.search)
    }

    func map(_ detail: MenuDetail)
        -> WebAdminAPI.Components.Schemas.WebMenuDetailSchema
    {
        .init(
            id: detail.id,
            key: detail.key,
            name: detail.name,
            notes: detail.notes,
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }

    func map(_ item: MenuList.Item)
        -> WebAdminAPI.Components.Schemas.WebMenuListItemSchema
    {
        .init(
            id: item.id,
            key: item.key,
            name: item.name,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    func map(
        _ query: WebAdminAPI.Components.Schemas
            .WebMenuItemListItemSearchQuerySchema
    ) -> MenuItemList.Query {
        .init(
            page: map(query.page),
            sort: [.init(field: .priority, direction: .asc)],
            search: query.filters.search
        )
    }

    func map(_ detail: MenuItemDetail)
        -> WebAdminAPI.Components.Schemas.WebMenuItemDetailSchema
    {
        .init(
            id: detail.id,
            menuId: detail.menuId,
            label: detail.label,
            url: detail.url,
            priority: detail.priority,
            isBlank: detail.isBlank,
            permission: detail.permission,
            authentication: detail.authentication.rawValue,
            notes: detail.notes,
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }

    func map(_ item: MenuItemList.Item)
        -> WebAdminAPI.Components.Schemas.WebMenuItemListItemSchema
    {
        .init(
            id: item.id,
            menuId: item.menuId,
            label: item.label,
            url: item.url,
            priority: item.priority,
            isBlank: item.isBlank,
            permission: item.permission,
            authentication: item.authentication.rawValue,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    func map(_ detail: SettingsDetail)
        -> WebAdminAPI.Components.Schemas.WebSettingsDetailSchema
    {
        .init(
            logo: detail.logo,
            logoDark: detail.logoDark,
            metaImage: detail.metaImage,
            primaryColor: detail.primaryColor,
            secondaryColor: detail.secondaryColor,
            tertiaryColor: detail.tertiaryColor,
            primaryFont: detail.primaryFont,
            secondaryFont: detail.secondaryFont,
            homePageId: detail.homePageId,
            locale: detail.locale,
            timezone: detail.timezone,
            title: detail.title,
            excerpt: detail.excerpt,
            noIndex: detail.noIndex,
            css: detail.css,
            js: detail.js
        )
    }
}
