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
    func map(
        _ query: WebAdminAPI.Components.Schemas
            .MenuItemQueryItemSearchRequestQuerySchema
    ) -> MenuItem.Search.Input.Query {
        .init(
            page: map(query.page),
            sort: (query.sort ?? [])
                .compactMap { sort in
                    guard
                        let field = MenuItem.Search.Input.Query.Sort.Field(
                            rawValue: sort.field.rawValue
                        )
                    else {
                        return nil
                    }
                    return .init(
                        field: field,
                        direction: sort.direction == .asc ? .asc : .desc
                    )
                },
            search: query.filters.search
        )
    }

    func map(_ detail: MenuItem.Add.Output)
        -> WebAdminAPI.Components.Schemas.MenuItemDetailSchema
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

    func map(_ detail: MenuItem.Edit.Output)
        -> WebAdminAPI.Components.Schemas.MenuItemDetailSchema
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

    func map(_ detail: MenuItem.Detail.Output)
        -> WebAdminAPI.Components.Schemas.MenuItemDetailSchema
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

    func mapList(_ item: MenuItem.List.Output.Item)
        -> WebAdminAPI.Components.Schemas.MenuItemListItemSchema
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

    func mapQuery(_ item: MenuItem.Search.Output.Item)
        -> WebAdminAPI.Components.Schemas.MenuItemQueryItemSchema
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
}
