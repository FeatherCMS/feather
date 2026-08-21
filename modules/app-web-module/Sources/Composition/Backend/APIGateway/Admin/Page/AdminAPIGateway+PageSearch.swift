import FeatherApplication
import FeatherContracts
import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func webPageSearch(
        _ input: Operations.WebPageSearch.Input
    ) async throws -> Operations.WebPageSearch.Output {
        let query: Components.Schemas.WebPageListItemSearchQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = useCases.makeListPages()
        let objectQuery = useCases.map(query)
        let subject = try await CurrentSubject.require()

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
                            items: list.items.map(useCases.map),
                            total: total
                        )
                    )
                )
            )
        )
    }
}
