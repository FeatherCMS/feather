import BlogAppAPI
import BlogApplication
import WebApplication

extension AppAPIGateway {
    func mapPublicAuthorSummary(
        _ summary: BlogApplication.Public.Author.Summary.Item
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

    func mapPublicAuthorLink(
        _ link: BlogApplication.Public.Author.Link
    ) -> BlogAppAPI.Components.Schemas.BlogAuthorLinkSchema {
        .init(
            label: link.label,
            url: link.url,
            isBlank: link.isBlank
        )
    }
}
