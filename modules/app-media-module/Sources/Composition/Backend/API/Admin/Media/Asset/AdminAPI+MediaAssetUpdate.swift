import FeatherApplication
import FeatherContracts
import MediaAdminAPI
import MediaApplication

extension MediaBackend {
    public func mediaAssetUpdate(
        _ input: Operations.MediaAssetUpdate.Input
    ) async throws -> Operations.MediaAssetUpdate.Output {
        let body: Components.Schemas.MediaAssetPatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let result = try await self.makeEditAsset()
            .execute(
                subject: subject,
                input: .init(
                    id: input.path.mediaAssetId,
                    title: body.title,
                    altText: body.altText
                )
            )

        return .ok(.init(body: .json(map(result))))
    }
}
