import FeatherApplication
import FeatherModuleKit
public import RedirectAdminAPI
import RedirectApplication
import RedirectDomain
import RedirectModule

extension AdminAPIGateway {

    public func redirectRuleQuery(
        _ input: Operations.RedirectRuleQuery.Input
    ) async throws -> Operations.RedirectRuleQuery.Output {
        let query:
            Components.Schemas.RedirectRuleQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = self.useCases.makeSearchRules()
        let objectQuery = try map(query)
        let subject = try await CurrentSubject.require()

        let result = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )

        let items = result.items.map(map)

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: responseQuery(from: query),
                        data: .init(items: items, total: result.total)
                    )
                )
            )
        )
    }

    private func mapSortDirection(
        _ direction: Components.Schemas.SortDirection
    ) -> FeatherApplication.Search.SortDirection {
        switch direction {
        case .asc:
            .asc
        case .desc:
            .desc
        }
    }

    private func searchPage(
        from query: Components.Schemas
            .RedirectRuleQueryItemSearchRequestQuerySchema
    ) -> FeatherApplication.Search.Page {
        let defaults = FeatherApplication.Search.Page()
        return FeatherApplication.Search
            .Page(
                size: query.page?.size ?? defaults.size,
                number: query.page?.number ?? defaults.number
            )
            .normalized()
    }

    private func responseQuery(
        from query: Components.Schemas
            .RedirectRuleQueryItemSearchRequestQuerySchema
    ) -> Components.Schemas.RedirectRuleQueryItemSearchResponseQuerySchema {
        let page = searchPage(from: query)
        let sort = query.sort?
            .map { rule in
                let field:
                    Components.Schemas
                        .RedirectRuleQueryItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload
                switch rule.field {
                case .id:
                    field = .id
                case .source:
                    field = .source
                case .destination:
                    field = .destination
                case .statusCode:
                    field = .statusCode
                case .notes:
                    field = .notes
                }
                return Components.Schemas
                    .RedirectRuleQueryItemSearchResponseQuerySchema
                    .SortPayloadPayload(field: field, direction: rule.direction)
            }

        return .init(
            page: .init(size: page.size, number: page.number),
            sort: sort,
            filters: .init(
                search: query.filters.search,
                statusCode: query.filters.statusCode
            )
        )
    }

    private func map(
        _ query: Components.Schemas
            .RedirectRuleQueryItemSearchRequestQuerySchema
    ) throws -> Rule.Search.Input.Query {
        let statusCode: Rule.Model.StatusCode?
        if let rawValue = query.filters.statusCode {
            guard let value = Rule.Model.StatusCode(rawValue: rawValue)
            else {
                throw Rule.Model.Error.invalidStatusCode
            }
            statusCode = value
        }
        else {
            statusCode = nil
        }

        return .init(
            page: searchPage(from: query),
            sort: (query.sort ?? [])
                .map { rule in
                    let field: Rule.Search.Input.Query.Sort.Field
                    switch rule.field {
                    case .id:
                        field = .id
                    case .source:
                        field = .source
                    case .destination:
                        field = .destination
                    case .statusCode:
                        field = .statusCode
                    case .notes:
                        field = .notes
                    }
                    return .init(
                        field: field,
                        direction: mapSortDirection(rule.direction)
                    )
                },
            search: query.filters.search,
            statusCode: statusCode
        )
    }

    private func map(
        _ item: Rule.Search.Output.Item
    ) -> Components.Schemas.RedirectRuleQueryItemSchema {
        .init(
            id: item.id,
            source: item.source,
            destination: item.destination,
            statusCode: item.statusCode.rawValue
        )
    }
}
