import FeatherModuleKit
public import MediaAdminAPI

extension AdminAPIGateway {
    public func mediaAssetNodeRemove(
        _ input: Operations.MediaAssetNodeRemove.Input
    ) async throws -> Operations.MediaAssetNodeRemove.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        _ = try await useCases.deleteAssetNodesAndFiles(
            subject: subject,
            assetIds: body.ids
        )
        return .noContent(.init())
    }

}
