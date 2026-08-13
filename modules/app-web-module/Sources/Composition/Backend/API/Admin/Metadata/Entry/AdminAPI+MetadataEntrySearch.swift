import FeatherApplication
import FeatherContracts
import WebAdminAPI
import WebApplication

extension WebBackend {

    public func webMetadataSearch(
        _ input: Operations.WebMetadataSearch.Input
    ) async throws -> Operations.WebMetadataSearch.Output {
        let query: Components.Schemas.WebMetadataListItemSearchQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = makeListMetadata()
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
