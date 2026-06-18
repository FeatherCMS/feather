import AdminOpenAPI
import UserApplication
import Application

extension AdminAPI {

    func userAccountSearch(
        _ input: Operations.UserAccountSearch.Input
    ) async throws -> Operations.UserAccountSearch.Output {
        let query: Components.Schemas.UserAccountListItemSearchQuerySchema
        switch input.body {
        case let .json(value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = modules.user.makeListAccounts()
        let objectQuery = map(query)

        let list = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )
        let total = try await useCase.count(
            subject: subject,
            input: .init(query: objectQuery)
        )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: query,
                        data: .init(
                            items: list.items.map(map),
                            total: total
                        )
                    )
                )
            )
        )
    }
}
