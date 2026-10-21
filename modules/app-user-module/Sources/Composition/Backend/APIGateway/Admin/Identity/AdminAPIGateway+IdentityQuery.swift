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
        let normalizedQuery = normalizedIdentityQuery(from: query)

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeSearchIdentities()
        let objectQuery = identitySearchInput(from: normalizedQuery)

        let result = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: responseIdentityQuery(from: normalizedQuery),
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

private func normalizedIdentityQuery(
    from query: Components.Schemas.UserIdentityQueryItemSearchRequestQuerySchema
) -> Components.Schemas.UserIdentityQueryItemSearchRequestQuerySchema {
    let page = searchPage(from: query)
    return .init(
        page: .init(size: page.size, number: page.number),
        sort: query.sort,
        filters: query.filters
    )
}

private func responseIdentityQuery(
    from query: Components.Schemas.UserIdentityQueryItemSearchRequestQuerySchema
) -> Components.Schemas.UserIdentityQueryItemSearchResponseQuerySchema {
    let page = searchPage(from: query)
    let sort = query.sort?
        .map { rule in
            Components.Schemas.UserIdentityQueryItemSearchResponseQuerySchema
                .SortPayloadPayload(field: .id, direction: rule.direction)
        }
    return .init(
        page: .init(size: page.size, number: page.number),
        sort: sort,
        filters: .init(
            search: query.filters.search,
            role: query.filters.role
        )
    )
}

private func searchPage(
    from query: Components.Schemas.UserIdentityQueryItemSearchRequestQuerySchema
) -> Search.Page {
    let defaults = Search.Page()
    return
        Search.Page(
            size: query.page?.size ?? defaults.size,
            number: query.page?.number ?? defaults.number
        )
        .normalized()
}

private func identitySearchInput(
    from query: Components.Schemas.UserIdentityQueryItemSearchRequestQuerySchema
) -> Identity.Search.Input.Query {
    .init(
        page: searchPage(from: query),
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
