import FeatherApplication
import FeatherDomain
import FeatherModuleKit
import Foundation
import WebAdminAPI
import WebAppAPI
import WebApplication
import WebDomain

extension AdminAPIGateway {
    func map(
        _ query: WebAdminAPI.Components.Schemas
            .PageQueryItemSearchRequestQuerySchema
    ) -> Page.Search.Input.Query {
        .init(
            page: map(query.page),
            sort: query.sort?
                .compactMap { sort in
                    guard
                        let field = Page.Search.Input.Query.Sort.Field(
                            rawValue: sort.field.rawValue
                        )
                    else { return nil }
                    return .init(
                        field: field,
                        direction: sort.direction == .asc ? .asc : .desc
                    )
                } ?? [],
            search: query.filters.search
        )
    }

    func map(_ detail: Page.Detail.Output)
        -> WebAdminAPI.Components.Schemas.PageDetailSchema
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

    func map(_ detail: Page.Add.Output)
        -> WebAdminAPI.Components.Schemas.PageDetailSchema
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

    func map(_ detail: Page.Edit.Output)
        -> WebAdminAPI.Components.Schemas.PageDetailSchema
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

    func map(_ item: Page.Search.Output.Item)
        -> WebAdminAPI.Components.Schemas.PageListItemSchema
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

    func mapQuery(_ item: Page.Search.Output.Item)
        -> WebAdminAPI.Components.Schemas.PageQueryItemSchema
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

    func mapList(_ item: Page.List.Output.Item)
        -> WebAdminAPI.Components.Schemas.PageListItemSchema
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
}
