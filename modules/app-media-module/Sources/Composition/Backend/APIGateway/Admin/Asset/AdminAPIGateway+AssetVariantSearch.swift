import FeatherModuleKit
public import MediaAdminAPI

extension AdminAPIGateway {
    public func mediaAssetVariantQuery(
        _ input: Operations.MediaAssetVariantQuery.Input
    ) async throws -> Operations.MediaAssetVariantQuery.Output {
        _ = try await CurrentSubject.require()
        do {
            let items = try await useCases.listAssociatedVariantFiles(
                assetId: input.path.mediaAssetId
            )
            return .ok(
                .init(
                    body: .json(
                        .init(
                            items: items.map(map)
                        )
                    )
                )
            )
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
