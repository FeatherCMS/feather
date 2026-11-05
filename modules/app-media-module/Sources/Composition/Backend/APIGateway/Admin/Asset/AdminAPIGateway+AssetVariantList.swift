import FeatherModuleKit
public import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaAssetVariantList(
        _ input: Operations.MediaAssetVariantList.Input
    ) async throws -> Operations.MediaAssetVariantList.Output {
        let subject = try await CurrentSubject.require()
        do {
            let result = try await useCases.makeResolveAssets()
                .execute(
                    subject: subject,
                    input: .init(
                        ids: [input.path.mediaAssetId],
                        variants: nil
                    )
                )
            guard let asset = result.items.first else {
                return .notFound(
                    .init(
                        body: .json(
                            .init(
                                error: .init(
                                    message: "Media asset not found.",
                                    reason: "media_asset_not_found"
                                )
                            )
                        )
                    )
                )
            }
            return .ok(
                .init(
                    body: .json(
                        .init(
                            items: asset.variants.map {
                                .init(
                                    variantId: $0.id,
                                    name: $0.name,
                                    _extension: $0.extension,
                                    url: mediaResolver.resolve(
                                        imagePath: $0.url
                                    )
                                        ?? $0.url
                                )
                            }
                        )
                    )
                )
            )
        }
        catch {
            return .notFound(
                .init(
                    body: .json(
                        .init(
                            error: .init(
                                message: "Media asset not found.",
                                reason: "media_asset_not_found"
                            )
                        )
                    )
                )
            )
        }
    }

}
