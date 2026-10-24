import FeatherApplication
import FeatherModuleKit
public import WebAdminAPI
import WebApplication
import Foundation
import WebModule

extension AdminAPIGateway {

    public func menuItemQuery(
        _ input: Operations.MenuItemQuery.Input
    ) async throws -> Operations.MenuItemQuery.Output {
        let query:
            Components.Schemas.MenuItemQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = useCases.makeSearchMenuItems()
        let objectQuery = mapMenuItemSearchQuery(query)
        let subject = try await CurrentSubject.require()

        let result = try await useCase.execute(
            subject: subject,
            input: .init(menuId: input.path.menuId, query: objectQuery)
        )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: .init(
                            page: .init(
                                size: objectQuery.page.size,
                                number: objectQuery.page.number
                            ),
                            sort: objectQuery.sort.map { sort in
                                let field:
                                    Components.Schemas
                                        .MenuItemQueryItemSearchResponseQuerySchema
                                        .SortPayloadPayload.FieldPayload
                                switch sort.field {
                                case .id: field = .id
                                case .label: field = .label
                                case .url: field = .url
                                case .priority: field = .priority
                                case .permission: field = .permission
                                case .createdAt: field = .createdAt
                                case .updatedAt: field = .updatedAt
                                }
                                return .init(
                                    field: field,
                                    direction: sort.direction == .asc
                                        ? .asc : .desc
                                )
                            },
                            filters: .init(search: objectQuery.search)
                        ),
                        data: .init(
                            items: result.items.map(mapMenuItemSearchItem),
                            total: result.total
                        )
                    )
                )
            )
        )
    }

    private func mapMenuItemSearchQuery(
        _ query: Components.Schemas.MenuItemQueryItemSearchRequestQuerySchema
    ) -> MenuItem.Search.Input.Query {
        .init(
            page: .init(
                size: query.page?.size ?? 20,
                number: query.page?.number ?? 1
            ),
            sort: (query.sort ?? []).compactMap { sort in
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

    private func mapMenuItemSearchItem(
        _ item: MenuItem.Search.Output.Item
    ) -> Components.Schemas.MenuItemQueryItemSchema {
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
