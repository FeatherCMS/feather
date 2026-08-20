import FeatherApplication
import FeatherContracts
import UserAdminAPI
import UserApplication

extension AdminAPIGateway {

    public func userIdentitySearch(
        _ input: Operations.UserIdentitySearch.Input
    ) async throws -> Operations.UserIdentitySearch.Output {
        let query: Components.Schemas.UserIdentityListItemSearchQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeListIdentities()
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
