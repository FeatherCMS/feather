import AdminOpenAPI
import Application
import AuthApplication

extension AdminAPI {

    func userCredentialSearch(
        _ input: Operations.UserCredentialSearch.Input
    ) async throws -> Operations.UserCredentialSearch.Output {
        let query: Components.Schemas.UserCredentialListItemSearchQuerySchema
        switch input.body {
        case let .json(value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = modules.auth.makeListCredential()
        let objectQuery = map(query)

        let list = try await useCase.execute(
            subject: subject,
            input: .init(
                query: objectQuery,
                accountID: query.filters.accountID
            )
        )
        let total = try await useCase.count(
            subject: subject,
            input: .init(
                query: objectQuery,
                accountID: query.filters.accountID
            )
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
