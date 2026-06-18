import AdminOpenAPI
import Application
import MediaApplication

extension AdminAPI {
    func mediaAssetUpdate(
        _ input: Operations.MediaAssetUpdate.Input
    ) async throws -> Operations.MediaAssetUpdate.Output {
        let body: Components.Schemas.MediaAssetPatchSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let result = try await modules.media.makeEditAsset()
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
