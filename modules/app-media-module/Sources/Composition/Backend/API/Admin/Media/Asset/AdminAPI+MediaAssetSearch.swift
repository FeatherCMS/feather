import FeatherApplication
import FeatherContracts
import MediaAdminAPI
import MediaApplication

extension MediaBackend {
    public func mediaAssetSearch(
        _ input: Operations.MediaAssetSearch.Input
    ) async throws -> Operations.MediaAssetSearch.Output {
        let query: Components.Schemas.MediaAssetListItemSearchQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.makeSearchAssets()
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
