import FeatherModuleKit
public import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaAssetGet(
        _ input: Operations.MediaAssetGet.Input
    ) async throws -> Operations.MediaAssetGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeDetailAsset()
        do {
            let result = try await useCase.execute(
                subject: subject,
                input: .init(id: input.path.mediaAssetId)
            )
            return .ok(.init(body: .json(map(result))))
        }
        catch {
            return .notFound(
                .init(
                    body: .json(
                        errorEnvelope(
                            message: "Media asset not found.",
                            reason: "media_asset_not_found"
                        )
                    )
                )
            )
        }
    }
}
