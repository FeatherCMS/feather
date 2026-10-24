import FeatherApplication
import FeatherModuleKit
public import WebAdminAPI
import WebApplication
import Foundation
import WebModule

extension AdminAPIGateway {

    public func menuQuery(
        _ input: Operations.MenuQuery.Input
    ) async throws -> Operations.MenuQuery.Output {
        let query: Components.Schemas.MenuQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = useCases.makeSearchMenus()
        let objectQuery = mapMenuSearchQuery(query)
        let subject = try await CurrentSubject.require()

        let result = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
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
                            sort: query.sort?
                                .map { sort in
                                    let field:
                                        Components.Schemas
                                            .MenuQueryItemSearchResponseQuerySchema
                                            .SortPayloadPayload.FieldPayload
                                    switch sort.field {
                                    case .id: field = .id
                                    case .key: field = .key
                                    case .name: field = .name
                                    case .createdAt: field = .createdAt
                                    case .updatedAt: field = .updatedAt
                                    }
                                    return .init(
                                        field: field,
                                        direction: sort.direction
                                    )
                                },
                            filters: .init(search: query.filters.search)
                        ),
                        data: .init(
                            items: result.items.map(mapMenuSearchItem),
                            total: result.total
                        )
                    )
                )
            )
        )
    }

    private func mapMenuSearchQuery(
        _ query: Components.Schemas.MenuQueryItemSearchRequestQuerySchema
    ) -> Menu.Search.Input.Query {
        .init(
            page: .init(
                size: query.page?.size ?? 20,
                number: query.page?.number ?? 1
            ),
            sort: query.sort?.compactMap { sort in
                guard
                    let field = Menu.Search.Input.Query.Sort.Field(
                        rawValue: sort.field.rawValue
                    )
                else {
                    return nil
                }
                return .init(
                    field: field,
                    direction: sort.direction == .asc ? .asc : .desc
                )
            } ?? [],
            search: query.filters.search
        )
    }

    private func mapMenuSearchItem(
        _ item: Menu.Search.Output.Item
    ) -> Components.Schemas.MenuQueryItemSchema {
        .init(
            id: item.id,
            key: item.key,
            name: item.name,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }
}
