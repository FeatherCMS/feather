import FeatherApplication
import Foundation
import UserAdminAPI
import UserApplication
import UserDomain
import UserModule

extension AdminAPIGateway {
    func timestamp(_ date: Date) -> Double {
        date.timeIntervalSince1970
    }

    func mapSortDirection(
        _ direction: Components.Schemas.SortDirection
    ) -> Search.SortDirection {
        switch direction {
        case .asc:
            .asc
        case .desc:
            .desc
        }
    }

    func map(
        _ page: Components.Schemas.SearchPageSchema?
    ) -> Search.Page {
        .init(
            size: page?.size ?? 20,
            number: page?.number ?? 1
        )
    }

    func map(
        _ query: Components.Schemas.UserIdentityListItemSearchRequestQuerySchema
    ) -> Identity.Search.Input.Query {
        .init(
            page: map(query.page),
            sort: (query.sort ?? [])
                .map { rule in
                    .init(
                        field: rule.field == .id ? .id : .id,
                        direction: mapSortDirection(rule.direction)
                    )
                },
            search: query.filters.search,
            role: query.filters.role
        )
    }

    func map(
        _ detail: Identity.Detail.Output
    ) -> Components.Schemas.UserIdentityDetailSchema {
        .init(
            id: detail.id,
            name: detail.name,
            status: .init(rawValue: detail.status.rawValue)!,
            roleIds: detail.roleIds
        )
    }

    func map(
        _ item: Identity.Search.Output.Item
    ) -> Components.Schemas.UserIdentityListItemSchema {
        .init(
            id: item.id,
            name: item.name,
            status: .init(rawValue: item.status.rawValue)!,
            roles: item.roles
        )
    }

    func map(
        _ query: Components.Schemas.UserRoleListItemSearchRequestQuerySchema
    ) -> Role.Search.Input.Query {
        .init(
            page: map(query.page),
            sort: (query.sort ?? [])
                .map { rule in
                    .init(
                        field: .id,
                        direction: mapSortDirection(rule.direction)
                    )
                },
            search: query.filters.search
        )
    }

    func map(
        _ detail: Role.Detail.Output
    ) -> Components.Schemas.UserRoleDetailSchema {
        .init(
            id: detail.id,
            key: detail.key,
            name: detail.name,
            notes: detail.notes
        )
    }

    func map(
        _ item: Role.Search.Output.Item
    ) -> Components.Schemas.UserRoleListItemSchema {
        .init(id: item.id, key: item.key, name: item.name)
    }

}
