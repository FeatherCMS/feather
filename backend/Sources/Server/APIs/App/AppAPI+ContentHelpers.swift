import Foundation
import WebApplication
import WebDomain
import AppOpenAPI
import BlogApplication
import MediaApplication

extension AppAPI {
    func mapPublicMenu(
        _ menu: PublicMenu
    ) -> Components.Schemas.WebMenuSchema {
        .init(
            id: menu.id,
            key: menu.key,
            name: menu.name,
            items: menu.items.map(mapPublicMenuItem)
        )
    }

    func mapPublicMenuItem(
        _ item: PublicMenuItem
    ) -> Components.Schemas.WebMenuItemSchema {
        .init(
            id: item.id,
            label: item.label,
            url: item.url,
            priority: item.priority,
            isBlank: item.isBlank
        )
    }

    func publicMedia(
        assetId: String?
    ) async -> PublicContentMedia? {
        guard let assetId, !assetId.isEmpty else {
            return nil
        }
        guard let asset = try? await modules.media.getAssetDetails(id: assetId)
        else {
            return nil
        }
        let originalURL = publicMediaURL(
            storageKey: asset.storageKey,
            isVariant: false
        )
        let variants =
            ((try? await modules.media.listAssociatedVariantFiles(
                assetId: assetId
            )) ?? [])
            .map {
                PublicContentMediaVariant(
                    id: $0.variantId,
                    url: publicMediaURL(
                        storageKey: $0.storageKey,
                        isVariant: true
                    ),
                    type: publicMediaType(from: $0.storageKey),
                    width: nil,
                    height: nil
                )
            }
        let defaultURL = preferredDefaultMediaURL(
            originalURL: originalURL,
            variants: variants
        )
        return .init(
            assetId: asset.id,
            originalURL: originalURL,
            defaultURL: defaultURL,
            variants: variants
        )
    }

    func publicMediaURL(
        storageKey: String,
        isVariant: Bool
    ) -> String {
        let prefix = isVariant ? "/media/variants/" : "/media/assets/"
        return "\(prefix)\(publicEncodedStorageKey(storageKey))"
    }

    func publicEncodedStorageKey(
        _ key: String
    ) -> String {
        let raw = publicCompactStorageKey(key)
        let allowed = CharacterSet(
            charactersIn:
                "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~/"
        )
        return raw.addingPercentEncoding(withAllowedCharacters: allowed) ?? raw
    }

    func publicCompactStorageKey(
        _ key: String
    ) -> String {
        let prefix = "media/assets/"
        guard key.hasPrefix(prefix) else { return key }
        return String(key.dropFirst(prefix.count))
    }

    func publicMediaType(
        from storageKey: String
    ) -> String {
        let fileName =
            storageKey.split(separator: "/").last.map(String.init) ?? storageKey
        guard let dotIndex = fileName.lastIndex(of: "."),
            dotIndex < fileName.index(before: fileName.endIndex)
        else {
            return "bin"
        }
        return String(fileName[fileName.index(after: dotIndex)...]).lowercased()
    }

    func preferredDefaultMediaURL(
        originalURL: String,
        variants: [PublicContentMediaVariant]
    ) -> String {
        if let preview = variants.first(where: {
            $0.id.localizedCaseInsensitiveContains("preview")
                || $0.url.localizedCaseInsensitiveContains("preview")
                || $0.id.localizedCaseInsensitiveContains("display")
                || $0.url.localizedCaseInsensitiveContains("display")
        }) {
            return preview.url
        }
        return variants.first?.url ?? originalURL
    }

    func publicTimestamp(
        _ date: Date?
    ) -> Double? {
        date?.timeIntervalSince1970
    }

    func mapPublicMetadata(
        _ metadata: MetadataDetail,
        title: String,
        excerpt: String,
        imageURL: String
    ) -> Components.Schemas.WebMetadataContentSchema {
        let resolved = ResolvedMetadata(
            metadata: metadata,
            fallbackTitle: title,
            fallbackExcerpt: excerpt,
            fallbackImageURL: imageURL
        )
        return .init(
            slug: metadata.slug,
            publicationDate: publicTimestamp(metadata.publicationDate),
            expirationDate: publicTimestamp(metadata.expirationDate),
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

    func mapPublicPostSummary(
        _ summary: PublicBlogPostSummary
    ) async -> Components.Schemas.BlogPostSummarySchema {
        let media = await publicMedia(assetId: summary.imageAssetId)
        return .init(
            id: summary.id,
            excerpt: summary.excerpt,
            imageURL: media?.defaultURL ?? summary.imageURL,
            media: mapPublicMedia(media),
            metadata: mapPublicMetadata(
                summary.metadata,
                title: summary.title,
                excerpt: summary.excerpt,
                imageURL: media?.defaultURL ?? summary.imageURL
            )
        )
    }

    func mapPublicAuthorSummary(
        _ summary: PublicBlogAuthorSummary
    ) async -> Components.Schemas.BlogAuthorSummarySchema {
        let media = await publicMedia(assetId: summary.imageAssetId)
        return .init(
            id: summary.id,
            name: summary.name,
            excerpt: summary.excerpt,
            content: summary.content,
            imageURL: media?.defaultURL ?? summary.imageURL,
            media: mapPublicMedia(media),
            metadata: mapPublicMetadata(
                summary.metadata,
                title: summary.name,
                excerpt: summary.excerpt,
                imageURL: media?.defaultURL ?? summary.imageURL
            )
        )
    }

    func mapPublicTagSummary(
        _ summary: PublicBlogTagSummary
    ) async -> Components.Schemas.BlogTagSummarySchema {
        let media = await publicMedia(assetId: summary.imageAssetId)
        return .init(
            id: summary.id,
            excerpt: summary.excerpt,
            imageURL: media?.defaultURL ?? summary.imageURL,
            media: mapPublicMedia(media),
            metadata: mapPublicMetadata(
                summary.metadata,
                title: summary.title,
                excerpt: summary.excerpt,
                imageURL: media?.defaultURL ?? summary.imageURL
            )
        )
    }

    func mapPublicAuthorLink(
        _ link: PublicBlogAuthorLink
    ) -> Components.Schemas.BlogAuthorLinkSchema {
        .init(
            label: link.label,
            url: link.url,
            isBlank: link.isBlank
        )
    }

    func mapPublicMedia(
        _ media: PublicContentMedia?
    ) -> Components.Schemas.MediaAssetSchema? {
        guard let media else {
            return nil
        }
        return .init(
            assetId: media.assetId,
            originalURL: media.originalURL,
            defaultURL: media.defaultURL,
            variants: media.variants.map {
                .init(
                    id: $0.id,
                    url: $0.url,
                    _type: $0.type,
                    width: $0.width.map(Int64.init),
                    height: $0.height.map(Int64.init)
                )
            }
        )
    }
}
