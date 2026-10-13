public import MediaAppAPI
import MediaApplication

extension AppAPIGateway {
    public func mediaAssetResolve(
        _ input: Operations.MediaAssetResolve.Input
    ) async throws -> Operations.MediaAssetResolve.Output {
        let body: Components.Schemas.MediaAssetResolveRequestSchema
        switch input.body {
        case .json(let value): body = value
        }

        let result = try await useCases.makePublicResolveMediaAssets()
            .execute(
                input: .init(ids: body.ids, variants: body.variants)
            )

        return .ok(
            .init(
                body: .json(
                    result.items.map {
                        .init(
                            id: $0.id,
                            url: $0.url,
                            variants: $0.variants.map {
                                .init(key: $0.key, url: $0.url)
                            }
                        )
                    }
                )
            )
        )
    }
}
