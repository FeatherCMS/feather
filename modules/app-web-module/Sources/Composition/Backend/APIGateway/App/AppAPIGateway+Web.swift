import FeatherModuleKit
import Foundation
import MediaApplication
import MediaBackend
public import WebAppAPI
import WebApplication
import WebDomain
import WebModule

extension AppAPIGateway {
    public func pageGet(
        _ input: Operations.PageGet.Input
    ) async throws -> Operations.PageGet.Output {
        do {
            let detail = try await useCases.makeDetailPublicPageByID()
                .execute(
                    input: .init(id: input.path.id)
                )
            let media = await publicMedia(assetId: detail.imageAssetId)
            return .ok(
                .init(
                    body: .json(
                        .init(
                            id: detail.id,
                            title: detail.title,
                            excerpt: detail.excerpt,
                            content: detail.content,
                            imageURL: media?.defaultURL ?? detail.imageURL,
                            media: mapPublicMedia(media),
                            metadata: mapPublicMetadata(
                                detail.metadata,
                                title: detail.title,
                                excerpt: detail.excerpt,
                                imageURL: media?.defaultURL ?? detail.imageURL
                            )
                        )
                    )
                )
            )
        }
        catch is WebApplication.Public.Page.Detail.Error {
            return .notFound(
                .init(
                    body: .json(
                        .init(
                            error: .init(
                                message: "Page not found",
                                reason:
                                    "No published page exists for this identifier."
                            )
                        )
                    )
                )
            )
        }
    }

    private func publicMedia(assetId: String?) async -> WebApplication.Public
        .Media?
    {
        guard let assetId, !assetId.isEmpty else { return nil }
        guard
            let asset =
                try? await mediaUseCases
                .makePublicResolveMediaAssets()
                .execute(input: .init(ids: [assetId], variants: nil))
                .items.first
        else {
            return nil
        }

        let originalURL =
            mediaResolver.resolve(imagePath: asset.url) ?? asset.url
        let variants = asset.variants.map {
            MediaURLVariant(
                key: $0.key,
                url: mediaResolver.resolve(imagePath: $0.url) ?? $0.url
            )
        }
        let defaultURL =
            mediaResolver.resolve(
                variants: variants,
                variantKey: "preview"
            ) ?? originalURL

        return .init(
            assetId: asset.id,
            originalURL: originalURL,
            defaultURL: defaultURL,
            variants: variants.map {
                .init(key: $0.key, url: $0.url)
            }
        )
    }

    private func mapPublicMedia(
        _ media: WebApplication.Public.Media?
    ) -> WebAppAPI.Components.Schemas.MediaAssetSchema? {
        guard let media else { return nil }
        return .init(
            assetId: media.assetId,
            originalURL: media.originalURL,
            defaultURL: media.defaultURL,
            variants: media.variants.map {
                .init(key: $0.key, url: $0.url)
            }
        )
    }

    private func mapPublicMetadata(
        _ metadata: Metadata.Snapshot,
        title: String,
        excerpt: String,
        imageURL: String
    ) -> WebAppAPI.Components.Schemas.MetadataContentSchema {
        let resolved = Metadata.Snapshot.Resolved(
            metadata: metadata,
            fallbackTitle: title,
            fallbackExcerpt: excerpt,
            fallbackImageURL: imageURL
        )
        return .init(
            slug: metadata.slug,
            template: metadata.template,
            publicationDate: metadata.publicationDate.timeIntervalSince1970,
            expirationDate: metadata.expirationDate?.timeIntervalSince1970,
            status: metadata.status.rawValue,
            title: resolved.title,
            excerpt: resolved.excerpt,
            imageURL: resolved.imageURL ?? "",
            canonicalURL: metadata.canonicalURL,
            noIndex: metadata.noIndex,
            cssCodeInjection: metadata.cssCodeInjection,
            javascriptCodeInjection: metadata.javascriptCodeInjection,
            structuredDataCodeInjection: metadata.structuredDataCodeInjection
        )
    }
}
