import FeatherApplication
import FeatherContracts
import MediaAdminAPI
import MediaApplication

extension MediaBackend {
    public func mediaAssetGet(
        _ input: Operations.MediaAssetGet.Input
    ) async throws -> Operations.MediaAssetGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.makeGetAssetDetails()
        do {
            let result = try await useCase.execute(
                subject: subject,
                input: .init(id: input.path.mediaAssetId)
            )
            return .ok(.init(body: .json(map(result))))
        }
        catch {
            return .notFound(.init())
        }
    }
}
