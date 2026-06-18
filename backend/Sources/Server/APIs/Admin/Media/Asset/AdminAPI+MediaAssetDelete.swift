import AdminOpenAPI
import Application
import MediaApplication

extension AdminAPI {
    func mediaAssetDelete(
        _ input: Operations.MediaAssetDelete.Input
    ) async throws -> Operations.MediaAssetDelete.Output {
        let subject = try await CurrentSubject.require()
        let deleted = try await modules.media.deleteAssetAndFiles(
            subject: subject,
            assetId: input.path.mediaAssetId
        )
        guard deleted else {
            return .notFound(.init())
        }
        return .noContent
    }
}
