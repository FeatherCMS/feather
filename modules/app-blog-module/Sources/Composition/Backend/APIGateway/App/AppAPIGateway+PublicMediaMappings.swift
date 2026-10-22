import BlogAppAPI
import BlogApplication
import FeatherModuleKit
import MediaApplication
import MediaBackend
import WebApplication
public import WebDomain

extension AppAPIGateway {
    func publicMedia(
        assetId: String?
    ) async -> WebApplication.Public.Page.Detail.Output.Media? {
        guard let assetId, !assetId.isEmpty else {
            return nil
        }
        guard let asset = try? await useCases.media.detailAsset(id: assetId)
        else {
            return nil
        }
        let resolver = useCases.mediaResolver
        let originalURL = resolver.resolve(imagePath: asset.url) ?? asset.url
        let variants =
            ((try? await useCases.media.listAssociatedVariantFiles(
                assetId: assetId
            )) ?? [])
            .map {
                PublicContentMediaVariant(
                    key: $0.key,
                    url: resolver.resolve(imagePath: $0.url) ?? $0.url
                )
            }
        let defaultURL =
            resolver.resolve(
                variants: variants,
                variantKey: "preview"
            ) ?? resolver.resolve(imagePath: originalURL) ?? ""
        return .init(
            assetId: asset.id,
            originalURL: originalURL,
            defaultURL: defaultURL,
            variants: variants
        )
    }

    func mapPublicMedia(
        _ media: WebApplication.Public.Page.Detail.Output.Media?
    ) -> BlogAppAPI.Components.Schemas.MediaAssetSchema? {
        guard let media else {
            return nil
        }
        return .init(
            assetId: media.assetId,
            originalURL: media.originalURL,
            defaultURL: media.defaultURL,
            variants: media.variants.map {
                .init(
                    key: $0.key,
                    url: $0.url
                )
            }
        )
    }
}
