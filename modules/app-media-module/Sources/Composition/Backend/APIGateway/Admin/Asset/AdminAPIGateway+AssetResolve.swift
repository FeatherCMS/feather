import FeatherContracts
public import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {

    public func mediaAssetResolve(
        _ input: Operations.MediaAssetResolve.Input
    ) async throws -> Operations.MediaAssetResolve.Output {
        let body: Components.Schemas.MediaAssetResolveRequestSchema
        switch input.body {
        case .json(let value): body = value
        }

        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeResolveAssets()
            .execute(
                subject: subject,
                input: .init(ids: body.ids, variants: body.variants)
            )

        return .ok(
            .init(body: .json(result.items.map(map)))
        )
    }
}
