import FeatherApplication
import FeatherContracts
import Foundation
import RedirectAdminAPI
import RedirectApplication
import RedirectContracts
import RedirectDomain

extension AdminAPIGateway {
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
        _ query: Components.Schemas.RedirectRuleListItemSearchQuerySchema
    ) -> RuleList.Query {
        .init(
            page: map(query.page),
            sort: (query.sort ?? [])
                .map { rule in
                    let field: RuleList.Query.Sort.Field
                    switch rule.field {
                    case .id:
                        field = .id
                    case .source:
                        field = .source
                    case .destination:
                        field = .destination
                    case .statusCode:
                        field = .statusCode
                    case .notes:
                        field = .notes
                    }
                    return .init(
                        field: field,
                        direction: mapSortDirection(rule.direction)
                    )
                },
            search: query.filters.search,
            statusCode: query.filters.statusCode.flatMap {
                StatusCode(rawValue: $0)
            }
        )
    }

    func map(
        _ detail: RuleDetail
    ) -> Components.Schemas.RedirectRuleDetailSchema {
        .init(
            id: detail.id,
            source: detail.source,
            destination: detail.destination,
            statusCode: detail.statusCode.rawValue,
            notes: detail.notes
        )
    }

    func map(
        _ item: RuleList.Item
    ) -> Components.Schemas.RedirectRuleListItemSchema {
        .init(
            id: item.id,
            source: item.source,
            destination: item.destination,
            statusCode: item.statusCode.rawValue
        )
    }

}
