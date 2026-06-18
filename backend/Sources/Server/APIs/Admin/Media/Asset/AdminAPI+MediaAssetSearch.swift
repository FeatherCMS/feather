import AdminOpenAPI
import Application
import MediaApplication

extension AdminAPI {
    func mediaAssetSearch(
        _ input: Operations.MediaAssetSearch.Input
    ) async throws -> Operations.MediaAssetSearch.Output {
        let query: Components.Schemas.MediaAssetListItemSearchQuerySchema
        switch input.body {
        case let .json(value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = modules.media.makeSearchAssets()
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
                        data: .init(items: list.items.map(map), total: total)
                    )
                )
            )
        )
    }
}
