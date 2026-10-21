import FeatherApplication
import FeatherModuleKit
public import UserAdminAPI
import UserApplication
import UserDomain
import UserModule

extension AdminAPIGateway {

    public func userIdentityQuery(
        _ input: Operations.UserIdentityQuery.Input
    ) async throws -> Operations.UserIdentityQuery.Output {
        let query:
            Components.Schemas.UserIdentityQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeSearchIdentities()
        let objectQuery = identitySearchInput(from: query)

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
                                identitySearchItemSchema(from: $0)
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
    _ query: Components.Schemas.UserIdentityQueryItemSearchRequestQuerySchema
) -> Components.Schemas.UserIdentityQueryItemSearchResponseQuerySchema {
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
        filters: .init(
            search: query.filters.search,
            role: query.filters.role
        )
    )
}

private func identitySearchInput(
    from query: Components.Schemas.UserIdentityQueryItemSearchRequestQuerySchema
) -> Identity.Search.Input.Query {
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
        search: query.filters.search,
        role: query.filters.role
    )
}

private func identitySearchItemSchema(
    from item: Identity.Search.Output.Item
) -> Components.Schemas.UserIdentityQueryItemSchema {
    .init(
        id: item.id,
        name: item.name,
        status: .init(rawValue: item.status.rawValue)!,
        roles: item.roles
    )
}
