import FeatherApplication
import FeatherContracts
import Foundation
import SystemAdminAPI
import SystemApplication

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
        _ query: Components.Schemas.SystemVariableListItemSearchQuerySchema
    ) -> VariableList.Query {
        let sort = (query.sort ?? [])
            .map { rule in
                let field: VariableList.Query.Sort.Field
                switch rule.field {
                case .id:
                    field = .id
                case .name:
                    field = .name
                case .value:
                    field = .value
                case .notes:
                    field = .notes
                }
                return VariableList.Query.Sort(
                    field: field,
                    direction: mapSortDirection(rule.direction)
                )
            }

        return .init(
            page: map(query.page),
            sort: sort,
            search: query.filters.search
        )
    }

    func map(
        _ detail: VariableDetail
    ) -> Components.Schemas.SystemVariableDetailSchema {
        .init(
            id: detail.id,
            value: detail.value,
            name: detail.name,
            notes: detail.notes
        )
    }

    func map(
        _ item: VariableList.Item
    ) -> Components.Schemas.SystemVariableListItemSchema {
        .init(
            id: item.id,
            value: item.value,
            name: item.name,
            notes: item.notes
        )
    }

    func map(
        _ query: Components.Schemas.SystemPermissionListItemSearchQuerySchema
    ) -> PermissionList.Query {
        let sort = (query.sort ?? [])
            .map { rule in
                let field: PermissionList.Query.Sort.Field
                switch rule.field {
                case .id:
                    field = .id
                case .name:
                    field = .name
                case .notes:
                    field = .notes
                }
                return PermissionList.Query.Sort(
                    field: field,
                    direction: mapSortDirection(rule.direction)
                )
            }

        return .init(
            page: map(query.page),
            sort: sort,
            search: query.filters.search
        )
    }

    func map(
        _ detail: PermissionDetail
    ) -> Components.Schemas.SystemPermissionDetailSchema {
        .init(
            id: detail.id,
            name: detail.name,
            notes: detail.notes
        )
    }

    func map(
        _ item: PermissionList.Item
    ) -> Components.Schemas.SystemPermissionListItemSchema {
        .init(
            id: item.id,
            name: item.name,
            notes: item.notes
        )
    }

    func map(
        _ job: JobDetail
    ) -> Components.Schemas.SystemJobSchema {
        .init(
            id: job.id,
            queueName: job.queueName,
            status: job.status,
            workerId: job.workerId,
            lastModified: job.lastModified.timeIntervalSince1970,
            payload: job.payload
        )
    }
}
