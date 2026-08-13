import FeatherApplication
import FeatherContracts
import Foundation
import UserAdminAPI
import UserApplication

extension UserBackend {
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
        _ page: Components.Schemas.SearchPageSchema
    ) -> Search.Page {
        .init(size: page.size, number: page.number)
    }

    func map(
        _ query: Components.Schemas.UserIdentityListItemSearchQuerySchema
    ) -> IdentityList.Query {
        .init(
            page: map(query.page),
            sort: (query.sort ?? [])
                .map { rule in
                    .init(
                        field: rule.field == .id ? .id : .id,
                        direction: mapSortDirection(rule.direction)
                    )
                },
            search: query.filters.search
        )
    }

    func map(
        _ detail: IdentityDetail
    ) -> Components.Schemas.UserIdentityDetailSchema {
        .init(
            id: detail.id,
            status: .init(rawValue: detail.status.rawValue)!,
            roleIds: detail.roleIds
        )
    }

    func map(
        _ item: IdentityList.Item
    ) -> Components.Schemas.UserIdentityListItemSchema {
        .init(
            id: item.id,
            status: .init(rawValue: item.status.rawValue)!
        )
    }

    func map(
        _ query: Components.Schemas.UserRoleListItemSearchQuerySchema
    ) -> RoleList.Query {
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
        _ detail: RoleDetail
    ) -> Components.Schemas.UserRoleDetailSchema {
        .init(id: detail.id, name: detail.name, notes: detail.notes)
    }

    func map(
        _ item: RoleList.Item
    ) -> Components.Schemas.UserRoleListItemSchema {
        .init(id: item.id, name: item.name)
    }

}
