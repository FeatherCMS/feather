public import ContactAdminAPI
import ContactApplication
import ContactModule
import FeatherApplication
import FeatherModuleKit

extension AdminAPIGateway {
    public func contactFormQuery(
        _ input: Operations.ContactFormQuery.Input
    ) async throws -> Operations.ContactFormQuery.Output {
        let query:
            Components.Schemas.ContactFormQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let page = searchPage(from: query)
        let sort = (query.sort ?? [])
            .map { rule in
                Form.Search.Input.Query.Sort(
                    field: searchSortField(from: rule.field),
                    direction: searchSortDirection(from: rule.direction)
                )
            }
        let result = try await useCases.makeSearchForms()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(
                    query: .init(
                        page: page,
                        sort: sort,
                        search: query.filters.search
                    )
                )
            )

        let responseSort = query.sort.map { rules in
            rules.map { rule in
                let field:
                    Components.Schemas
                        .ContactFormQueryItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload
                switch rule.field {
                case .key:
                    field = .key
                case .name:
                    field = .name
                }
                return Components.Schemas
                    .ContactFormQueryItemSearchResponseQuerySchema
                    .SortPayloadPayload(
                        field: field,
                        direction: rule.direction
                    )
            }
        }

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: .init(
                            page: .init(size: page.size, number: page.number),
                            sort: responseSort,
                            filters: .init(search: query.filters.search)
                        ),
                        data: .init(
                            items: result.items.map(searchItemSchema(from:)),
                            total: result.total
                        )
                    )
                )
            )
        )
    }

    private func searchPage(
        from query: Components.Schemas
            .ContactFormQueryItemSearchRequestQuerySchema
    ) -> Search.Page {
        let defaults = Search.Page()
        return
            Search.Page(
                size: query.page?.size ?? defaults.size,
                number: query.page?.number ?? defaults.number
            )
            .normalized()
    }

    private func searchSortField(
        from field: Components.Schemas
            .ContactFormQueryItemSearchRequestQuerySchema.SortPayloadPayload
            .FieldPayload
    ) -> Form.Search.Input.Query.Sort.Field {
        switch field {
        case .key: .key
        case .name: .name
        }
    }

    private func searchSortDirection(
        from direction: Components.Schemas.SortDirection
    ) -> Search.SortDirection {
        switch direction {
        case .asc: .asc
        case .desc: .desc
        }
    }

    private func searchItemSchema(
        from item: Form.Search.Output.Item
    ) -> Components.Schemas.ContactFormQueryItemSchema {
        .init(id: item.id, key: item.key, name: item.name)
    }
}
