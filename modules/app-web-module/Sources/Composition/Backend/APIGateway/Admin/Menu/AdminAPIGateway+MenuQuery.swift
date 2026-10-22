import FeatherApplication
import FeatherModuleKit
public import WebAdminAPI
import WebApplication

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
        let objectQuery = map(query)
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
                            items: result.items.map(mapQuery),
                            total: result.total
                        )
                    )
                )
            )
        )
    }
}
