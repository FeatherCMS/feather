import FeatherApplication
import FeatherModuleKit
public import SystemAdminAPI
import SystemApplication
import SystemModule

extension AdminAPIGateway {

    public func systemVariableQuery(
        _ input: Operations.SystemVariableQuery.Input
    ) async throws -> Operations.SystemVariableQuery.Output {
        let query:
            Components.Schemas.SystemVariableQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }
        let normalizedQuery = normalizedVariableQuery(from: query)

        let useCase = self.useCases.makeSearchVariables()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(query: variableSearchQuery(from: normalizedQuery))
        )

        let items = result.items.map(variableQueryItemSchema(from:))

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: responseVariableQuery(from: normalizedQuery),
                        data: .init(items: items, total: result.total)
                    )
                )
            )
        )
    }

    private func normalizedVariableQuery(
        from query: Components.Schemas
            .SystemVariableQueryItemSearchRequestQuerySchema
    ) -> Components.Schemas.SystemVariableQueryItemSearchRequestQuerySchema {
        let page = searchPage(from: query)

        return .init(
            page: .init(size: page.size, number: page.number),
            sort: query.sort,
            filters: query.filters
        )
    }

    private func responseVariableQuery(
        from query: Components.Schemas
            .SystemVariableQueryItemSearchRequestQuerySchema
    ) -> Components.Schemas.SystemVariableQueryItemSearchResponseQuerySchema {
        let page = searchPage(from: query)
        let sort = query.sort?
            .map { rule in
                let field:
                    Components.Schemas
                        .SystemVariableQueryItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload
                switch rule.field {
                case .key:
                    field = .key
                case .name:
                    field = .name
                case .value:
                    field = .value
                case .notes:
                    field = .notes
                }
                return Components.Schemas
                    .SystemVariableQueryItemSearchResponseQuerySchema
                    .SortPayloadPayload(field: field, direction: rule.direction)
            }

        return .init(
            page: .init(size: page.size, number: page.number),
            sort: sort,
            filters: .init(search: query.filters.search, ids: query.filters.ids)
        )
    }

    private func searchPage(
        from query: Components.Schemas
            .SystemVariableQueryItemSearchRequestQuerySchema
    ) -> Search.Page {
        let defaults = Search.Page()
        return
            Search.Page(
                size: query.page?.size ?? defaults.size,
                number: query.page?.number ?? defaults.number
            )
            .normalized()
    }

    private func variableSearchQuery(
        from query: Components.Schemas
            .SystemVariableQueryItemSearchRequestQuerySchema
    ) -> Variable.Search.Input.Query {
        let sort = (query.sort ?? [])
            .map { rule in
                let field: Variable.Search.Input.Query.Sort.Field
                switch rule.field {
                case .key:
                    field = .key
                case .name:
                    field = .name
                case .value:
                    field = .value
                case .notes:
                    field = .notes
                }
                return Variable.Search.Input.Query.Sort(
                    field: field,
                    direction: searchSortDirection(from: rule.direction)
                )
            }

        return .init(
            page: searchPage(from: query),
            sort: sort,
            search: query.filters.search,
            ids: query.filters.ids
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

    private func variableQueryItemSchema(
        from item: Variable.Search.Output.Item
    ) -> Components.Schemas.SystemVariableQueryItemSchema {
        .init(
            id: item.id,
            key: item.key,
            value: item.value,
            name: item.name,
            notes: item.notes
        )
    }
}
