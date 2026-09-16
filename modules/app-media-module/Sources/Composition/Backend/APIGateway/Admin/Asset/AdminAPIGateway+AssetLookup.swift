import FeatherApplication
import FeatherContracts
import FeatherDomain
import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {

    public func mediaAssetLookup(
        _ input: Operations.MediaAssetLookup.Input
    ) async throws -> Operations.MediaAssetLookup.Output {
        let body: Components.Schemas.MediaAssetLookupRequestSchema
        switch input.body {
        case .json(let value): body = value
        }

        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeLookupAssets().execute(
            subject: subject,
            input: .init(ids: body.ids, variants: body.variants)
        )

        return .ok(
            .init(body: .json(result.items.map(map)))
        )
    }
}
