import FeatherApplication
import FeatherModuleKit
public import UserAdminAPI
import UserApplication
import UserModule

extension AdminAPIGateway {

    public func userRoleQuery(
        _ input: Operations.UserRoleQuery.Input
    ) async throws -> Operations.UserRoleQuery.Output {
        let query: Components.Schemas.UserRoleQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeSearchRoles()
        let objectQuery = roleSearchInput(from: query)

        let result = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: mapResponse(query),
                        data: .init(
                            items: result.items.map {
                                roleSearchItemSchema(from: $0)
                            },
                            total: result.total
                        )
                    )
                )
            )
        )
    }
}

private func mapResponse(
    _ query: Components.Schemas.UserRoleQueryItemSearchRequestQuerySchema
) -> Components.Schemas.UserRoleQueryItemSearchResponseQuerySchema {
    .init(
        page: .init(
            size: query.page?.size ?? 20,
            number: query.page?.number ?? 1
        ),
        sort: query.sort?
            .map {
                .init(
                    field: .init(rawValue: $0.field.rawValue)!,
                    direction: $0.direction
                )
            },
        filters: .init(search: query.filters.search)
    )
}

private func roleSearchInput(
    from query: Components.Schemas.UserRoleQueryItemSearchRequestQuerySchema
) -> Role.Search.Input.Query {
    .init(
        page: .init(
            size: query.page?.size ?? 20,
            number: query.page?.number ?? 1
        ),
        sort: (query.sort ?? [])
            .map { rule in
                let direction: Search.SortDirection
                switch rule.direction {
                case .asc:
                    direction = .asc
                case .desc:
                    direction = .desc
                }
                return .init(field: .id, direction: direction)
            },
        search: query.filters.search
    )
}

private func roleSearchItemSchema(
    from item: Role.Search.Output.Item
) -> Components.Schemas.UserRoleQueryItemSchema {
    .init(id: item.id, key: item.key, name: item.name)
}
