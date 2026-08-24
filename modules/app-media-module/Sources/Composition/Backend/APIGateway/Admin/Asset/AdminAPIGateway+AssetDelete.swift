import FeatherApplication
import FeatherContracts
import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaAssetDelete(
        _ input: Operations.MediaAssetDelete.Input
    ) async throws -> Operations.MediaAssetDelete.Output {
        let subject = try await CurrentSubject.require()
        let deleted = try await useCases.deleteAssetAndFiles(
            subject: subject,
            assetId: input.path.mediaAssetId
        )
        guard deleted else {
            return .notFound(.init())
        }
        return .noContent
    }
}
