import FeatherApplication
import FeatherModuleKit
public import RedirectAdminAPI
import RedirectApplication
import RedirectModule

extension AdminAPIGateway {

    public func redirectRuleQuery(
        _ input: Operations.RedirectRuleQuery.Input
    ) async throws -> Operations.RedirectRuleQuery.Output {
        let query: Components.Schemas.RedirectRuleQueryItemSearchRequestQuerySchema
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
                        query: query,
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

    private func map(
        _ page: Components.Schemas.SearchPageSchema
    ) -> FeatherApplication.Search.Page {
        .init(size: page.size, number: page.number)
    }

    private func map(
        _ query: Components.Schemas.RedirectRuleQueryItemSearchRequestQuerySchema
    ) throws -> RedirectModule.Rule.Search.Input.Query {
        let statusCode: RedirectModule.Rule.StatusCode?
        if let rawValue = query.filters.statusCode {
            guard let value = RedirectModule.Rule.StatusCode(rawValue: rawValue)
            else {
                throw RedirectModule.Rule.Model.Error.invalidStatusCode
            }
            statusCode = value
        } else {
            statusCode = nil
        }

        return .init(
            page: map(query.page),
            sort: (query.sort ?? [])
                .map { rule in
                    let field: RedirectModule.Rule.Search.Input.Query.Sort.Field
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
        _ item: RedirectModule.Rule.Search.Output.Item
    ) -> Components.Schemas.RedirectRuleQueryItemSchema {
        .init(
            id: item.id,
            source: item.source,
            destination: item.destination,
            statusCode: item.statusCode.rawValue
        )
    }
}
