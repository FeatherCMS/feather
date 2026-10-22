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
            .MenuQueryItemSearchRequestQuerySchema
    ) -> Menu.Search.Input.Query {
        .init(
            page: map(query.page),
            sort: query.sort?
                .compactMap { sort in
                    guard
                        let field = Menu.Search.Input.Query.Sort.Field(
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

    func map(_ detail: Menu.Detail.Output)
        -> WebAdminAPI.Components.Schemas.MenuDetailSchema
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

    func map(_ output: Menu.Edit.Output)
        -> WebAdminAPI.Components.Schemas.MenuDetailSchema
    {
        .init(
            id: output.id,
            key: output.key,
            name: output.name,
            notes: output.notes,
            createdAt: output.createdAt.timeIntervalSince1970,
            updatedAt: output.updatedAt.timeIntervalSince1970
        )
    }

    func map(_ output: Menu.Add.Output)
        -> WebAdminAPI.Components.Schemas.MenuDetailSchema
    {
        .init(
            id: output.id,
            key: output.key,
            name: output.name,
            notes: output.notes,
            createdAt: output.createdAt.timeIntervalSince1970,
            updatedAt: output.updatedAt.timeIntervalSince1970
        )
    }

    func mapQuery(_ item: Menu.Search.Output.Item)
        -> WebAdminAPI.Components.Schemas.MenuQueryItemSchema
    {
        .init(
            id: item.id,
            key: item.key,
            name: item.name,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    func mapList(_ item: Menu.List.Output.Item)
        -> WebAdminAPI.Components.Schemas.MenuListItemSchema
    {
        .init(
            id: item.id,
            key: item.key,
            name: item.name,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }
}
