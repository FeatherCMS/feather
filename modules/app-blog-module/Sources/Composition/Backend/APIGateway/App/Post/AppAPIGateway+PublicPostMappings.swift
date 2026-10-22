import BlogAppAPI
import BlogApplication
import WebApplication

extension AppAPIGateway {
    func mapPublicPostSummary(
        _ summary: BlogApplication.Public.Post.Summary.Output
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
}
