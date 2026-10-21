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
        let normalizedQuery = normalizedRoleQuery(from: query)

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeSearchRoles()
        let objectQuery = roleSearchInput(from: normalizedQuery)

        let result = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: responseRoleQuery(from: normalizedQuery),
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

private func normalizedRoleQuery(
    from query: Components.Schemas.UserRoleQueryItemSearchRequestQuerySchema
) -> Components.Schemas.UserRoleQueryItemSearchRequestQuerySchema {
    let page = searchPage(from: query)
    return .init(
        page: .init(size: page.size, number: page.number),
        sort: query.sort,
        filters: query.filters
    )
}

private func responseRoleQuery(
    from query: Components.Schemas.UserRoleQueryItemSearchRequestQuerySchema
) -> Components.Schemas.UserRoleQueryItemSearchResponseQuerySchema {
    let page = searchPage(from: query)
    let sort = query.sort?
        .map { rule in
            let field:
                Components.Schemas.UserRoleQueryItemSearchResponseQuerySchema
                    .SortPayloadPayload.FieldPayload
            switch rule.field {
            case .id:
                field = .id
            case .name:
                field = .name
            case .notes:
                field = .notes
            }
            return Components.Schemas.UserRoleQueryItemSearchResponseQuerySchema
                .SortPayloadPayload(field: field, direction: rule.direction)
        }
    return .init(
        page: .init(size: page.size, number: page.number),
        sort: sort,
        filters: .init(search: query.filters.search)
    )
}

private func searchPage(
    from query: Components.Schemas.UserRoleQueryItemSearchRequestQuerySchema
) -> Search.Page {
    let defaults = Search.Page()
    return
        Search.Page(
            size: query.page?.size ?? defaults.size,
            number: query.page?.number ?? defaults.number
        )
        .normalized()
}

private func roleSearchInput(
    from query: Components.Schemas.UserRoleQueryItemSearchRequestQuerySchema
) -> Role.Search.Input.Query {
    .init(
        page: searchPage(from: query),
        sort: (query.sort ?? [])
            .map { rule in
                let field: Role.Search.Input.Query.Sort.Field
                switch rule.field {
                case .id:
                    field = .id
                case .name:
                    field = .name
                case .notes:
                    field = .notes
                }
                let direction = searchSortDirection(from: rule.direction)
                return .init(field: field, direction: direction)
            },
        search: query.filters.search
    )
}

private func searchSortDirection(
    from direction: Components.Schemas.SortDirection
) -> Search.SortDirection {
    switch direction {
    case .asc:
        .asc
    case .desc:
        .desc
    }
}

private func roleSearchItemSchema(
    from item: Role.Search.Output.Item
) -> Components.Schemas.UserRoleQueryItemSchema {
    .init(id: item.id, key: item.key, name: item.name, notes: item.notes)
}
