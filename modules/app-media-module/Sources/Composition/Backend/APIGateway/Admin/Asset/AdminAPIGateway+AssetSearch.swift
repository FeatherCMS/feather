import FeatherModuleKit
public import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaAssetQuery(
        _ input: Operations.MediaAssetQuery.Input
    ) async throws -> Operations.MediaAssetQuery.Output {
        let query:
            Components.Schemas.MediaAssetNodeQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeSearchAssets()
        let objectQuery = map(query)
        let result = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: responseQuery(from: query),
                        data: .init(
                            items: result.items.map(map),
                            total: result.total
                        )
                    )
                )
            )
        )
    }
}
