import FeatherModuleKit
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
        try await useCases.deleteAssetNodesAndFiles(
            subject: subject,
            assetIds: body.ids
        )
        return .noContent(.init())
    }

}
