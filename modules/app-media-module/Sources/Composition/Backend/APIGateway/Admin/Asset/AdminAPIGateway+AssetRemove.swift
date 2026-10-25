import FeatherModuleKit
import MediaApplication
public import MediaAdminAPI

extension AdminAPIGateway {
    public func mediaAssetDelete(
        _ input: Operations.MediaAssetDelete.Input
    ) async throws -> Operations.MediaAssetDelete.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        _ = try await useCases.makeRemoveAsset().execute(
            subject: subject,
            input: .init(ids: body.ids)
        )
        return .noContent(.init())
    }

}
