import FeatherApplication
import FeatherModuleKit
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func webMenuItemQuery(
        _ input: Operations.WebMenuItemQuery.Input
    ) async throws -> Operations.WebMenuItemQuery.Output {
        let query:
            Components.Schemas.WebMenuItemQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = useCases.makeSearchMenuItems()
        let objectQuery = useCases.map(query)
        let subject = try await CurrentSubject.require()

        let result = try await useCase.execute(
            subject: subject,
            input: .init(menuId: input.path.webMenuId, query: objectQuery)
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
                                        .WebMenuItemQueryItemSearchResponseQuerySchema
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
                            items: result.items.map(useCases.mapQuery),
                            total: result.total
                        )
                    )
                )
            )
        )
    }
}
