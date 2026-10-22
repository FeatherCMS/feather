import FeatherApplication
import FeatherModuleKit
public import WebAdminAPI
import WebApplication

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
        let objectQuery = map(query)
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
                            items: result.items.map(mapQuery),
                            total: result.total
                        )
                    )
                )
            )
        )
    }
}
