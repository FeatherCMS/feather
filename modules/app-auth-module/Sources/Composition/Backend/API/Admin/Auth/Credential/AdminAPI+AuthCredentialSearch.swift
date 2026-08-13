import AuthAdminAPI
import AuthApplication
import FeatherApplication
import FeatherContracts

extension AuthBackend {

    public func authCredentialSearch(
        _ input: Operations.AuthCredentialSearch.Input
    ) async throws -> Operations.AuthCredentialSearch.Output {
        let query: Components.Schemas.AuthCredentialListItemSearchQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.makeListCredential()
        let objectQuery = map(query)
        let userId =
            query.filters.userId?.isEmpty == true
            ? nil
            : query.filters.userId

        let list = try await useCase.execute(
            subject: subject,
            input: .init(
                query: objectQuery,
                userId: userId
            )
        )
        let total = try await useCase.count(
            subject: subject,
            input: .init(
                query: objectQuery,
                userId: userId
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
