import BlogApplication
import FeatherModuleKit
import MediaApplication
import MediaBackend
import WebApplication

extension AppAPIGateway {
    func publicMedia(
        assetId: String?
    ) async -> WebApplication.Public.Media? {
        guard let assetId, !assetId.isEmpty else {
            return nil
        }
        guard
            let asset = try? await useCases.media
                .makePublicResolveMediaAssets()
                .execute(input: .init(ids: [assetId], variants: nil))
                .items.first
        else {
            return nil
        }
        let resolver = useCases.mediaResolver
        let originalURL = resolver.resolve(imagePath: asset.url) ?? asset.url
        let variants = asset.variants.map {
            MediaURLVariant(
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
            variants: variants.map {
                .init(key: $0.key, url: $0.url)
            }
        )
    }
}
