import AdminOpenAPI
import RedirectApplication
import Application

extension AdminAPI {

    func redirectRuleSearch(
        _ input: Operations.RedirectRuleSearch.Input
    ) async throws -> Operations.RedirectRuleSearch.Output {
        let query: Components.Schemas.RedirectRuleListItemSearchQuerySchema
        switch input.body {
        case let .json(value):
            query = value
        }

        let useCase = modules.redirect.makeListRules()
        let objectQuery = map(query)
        let subject = try await CurrentSubject.require()

        let list = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )
        let total = try await useCase.count(
            subject: subject,
            input: .init(query: objectQuery)
        )

        let items = list.items.map(map)

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: query,
                        data: .init(items: items, total: total)
                    )
                )
            )
        )
    }
}
