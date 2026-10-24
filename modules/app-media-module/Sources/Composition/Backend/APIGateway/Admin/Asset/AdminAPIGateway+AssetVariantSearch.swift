import FeatherModuleKit
public import MediaAdminAPI
import MediaBackend

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
                            items: items.map(mapAssociatedVariant)
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

    private func mapAssociatedVariant(
        _ item: MediaBackend.UseCases.AssociatedVariantFile
    ) -> Components.Schemas.MediaAssetVariantListItemSchema {
        .init(
            variantId: item.variantId,
            name: item.name,
            _extension: item.extension,
            url: mediaResolver.resolve(imagePath: item.url) ?? item.url
        )
    }
}
