import BlogAppAPI
import BlogApplication

extension AppAPIGateway {
    func mapPublicTagSummary(
        _ summary: Public.Tag.Summary.Output
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
}
