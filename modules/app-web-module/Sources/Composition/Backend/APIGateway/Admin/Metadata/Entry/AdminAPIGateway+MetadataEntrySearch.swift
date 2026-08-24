import FeatherApplication
import FeatherContracts
import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func webMetadataSearch(
        _ input: Operations.WebMetadataSearch.Input
    ) async throws -> Operations.WebMetadataSearch.Output {
        let query: Components.Schemas.WebMetadataListItemSearchQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = useCases.makeListMetadata()
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

        let items = list.items.map(useCases.map)

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
