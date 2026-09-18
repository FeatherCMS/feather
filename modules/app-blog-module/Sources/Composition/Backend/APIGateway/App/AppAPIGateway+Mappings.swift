import BlogAppAPI
import BlogApplication
import Foundation
import MediaApplication
import MediaBackend
import WebApplication
import WebDomain

extension AppAPIGateway {

    func publicMedia(
        assetId: String?
    ) async -> PublicContentMedia? {
        guard let assetId, !assetId.isEmpty else {
            return nil
        }
        guard let asset = try? await useCases.media.getAssetDetails(id: assetId)
        else {
            return nil
        }
        let originalURL = asset.url
        let variants =
            ((try? await useCases.media.listAssociatedVariantFiles(
                assetId: assetId
            )) ?? [])
            .map {
                PublicContentMediaVariant(
                    key: $0.key,
                    url:
                        "/media/variants/\(asset.id)/\($0.key).\($0.extension)"
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

    func preferredDefaultMediaURL(
        originalURL: String,
        variants: [PublicContentMediaVariant]
    ) -> String {
        if let preview = variants.first(where: {
            $0.key == "preview" || $0.key == "display"
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
            template: publicTemplate(for: metadata),
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

    private func publicTemplate(
        for metadata: MetadataDetail
    ) -> String {
        guard metadata.template == "default" else {
            return metadata.template
        }
        switch metadata.referenceType {
        case "blog.post": return "blog.post"
        case "blog.author": return "blog.author"
        case "blog.tag": return "blog.tag"
        default: return metadata.template
        }
    }

    func mapPublicPostSummary(
        _ summary: PublicBlogPostSummary
    ) async -> BlogAppAPI.Components.Schemas.BlogPostSummarySchema {
        let media = await publicMedia(assetId: summary.imageAssetId)
        var authors: [BlogAppAPI.Components.Schemas.BlogAuthorSummarySchema] =
            []
        for author in summary.authors {
            authors.append(await mapPublicAuthorSummary(author))
        }
        var tags: [BlogAppAPI.Components.Schemas.BlogTagSummarySchema] = []
        for tag in summary.tags {
            tags.append(await mapPublicTagSummary(tag))
        }
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
            ),
            authors: authors,
            tags: tags
        )
    }

    func mapPublicAuthorSummary(
        _ summary: PublicBlogAuthorSummary
    ) async -> BlogAppAPI.Components.Schemas.BlogAuthorSummarySchema {
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
    ) async -> BlogAppAPI.Components.Schemas.BlogTagSummarySchema {
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
    ) -> BlogAppAPI.Components.Schemas.BlogAuthorLinkSchema {
        .init(
            label: link.label,
            url: link.url,
            isBlank: link.isBlank
        )
    }

    func mapPublicMedia(
        _ media: PublicContentMedia?
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

    func mapPublicMediaList(
        assetIDs: [String]
    ) async -> [BlogAppAPI.Components.Schemas.MediaAssetSchema] {
        var result: [BlogAppAPI.Components.Schemas.MediaAssetSchema] = []
        result.reserveCapacity(assetIDs.count)
        for assetID in assetIDs {
            if let media = mapPublicMedia(await publicMedia(assetId: assetID)) {
                result.append(media)
            }
        }
        return result
    }
}
