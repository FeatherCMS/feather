import AccountAdminAPI
import AccountApplication
import FeatherApplication
import FeatherContracts
import Foundation

extension AdminAPIGateway {
    func timestamp(_ date: Date) -> Double {
        date.timeIntervalSince1970
    }

    func map(
        _ page: Components.Schemas.SearchPageSchema
    ) -> Search.Page {
        .init(size: page.size, number: page.number)
    }

    func mapSortDirection(
        _ direction: Components.Schemas.SortDirection
    ) -> Search.SortDirection {
        switch direction {
        case .asc: .asc
        case .desc: .desc
        }
    }

    func map(
        _ query: Components.Schemas.AccountInvitationListItemSearchQuerySchema
    ) -> InvitationList.Query {
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
        _ detail: InvitationDetail
    ) -> Components.Schemas.AccountInvitationDetailSchema {
        .init(
            id: detail.id,
            email: detail.email,
            token: detail.token,
            roleIds: detail.roleIDs,
            expiresAt: timestamp(detail.expiresAt)
        )
    }

    func map(
        _ item: InvitationList.Item
    ) -> Components.Schemas.AccountInvitationListItemSchema {
        .init(
            id: item.id,
            email: item.email,
            token: item.token,
            roleIds: item.roleIDs,
            expiresAt: timestamp(item.expiresAt)
        )
    }
}
