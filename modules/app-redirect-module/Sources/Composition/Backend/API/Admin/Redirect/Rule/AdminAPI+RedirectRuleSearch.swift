import FeatherApplication
import FeatherContracts
import RedirectAdminAPI
import RedirectApplication

extension RedirectBackend {

    public func redirectRuleSearch(
        _ input: Operations.RedirectRuleSearch.Input
    ) async throws -> Operations.RedirectRuleSearch.Output {
        let query: Components.Schemas.RedirectRuleListItemSearchQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = self.makeListRules()
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
