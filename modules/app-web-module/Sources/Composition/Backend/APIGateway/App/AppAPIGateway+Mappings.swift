import FeatherModuleKit
import Foundation
import MediaApplication
import MediaBackend
import WebAppAPI
import WebApplication
import WebDomain
import WebModule

extension AppAPIGateway {
    func publicMedia(assetId: String?) async -> Public.Media? {
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

    func mapPublicMedia(
        _ media: Public.Media?
    ) -> WebAppAPI.Components.Schemas.MediaAssetSchema? {
        guard let media else { return nil }
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

    func mapPublicMenu(
        _ menu: Menu.Public.List.Output.Menu
    ) -> WebAppAPI.Components.Schemas.MenuSchema {
        .init(
            id: menu.id,
            key: menu.key,
            name: menu.name,
            items: menu.items.map {
                .init(
                    id: $0.id,
                    label: $0.label,
                    url: $0.url,
                    priority: $0.priority,
                    isBlank: $0.isBlank
                )
            }
        )
    }

    func mapPublicMetadata(
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
