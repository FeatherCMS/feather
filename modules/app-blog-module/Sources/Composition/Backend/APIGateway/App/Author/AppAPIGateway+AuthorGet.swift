public import BlogAppAPI
import BlogApplication

extension AppAPIGateway {
    public func blogAuthorGet(
        _ input: Operations.BlogAuthorGet.Input
    ) async throws -> Operations.BlogAuthorGet.Output {
        do {
            let detail = try await self.useCases.makeGetPublicAuthor()
                .execute(input: .init(id: input.path.id))
            let media = await publicMedia(assetId: detail.imageAssetId)
            var posts: [Components.Schemas.BlogPostSummarySchema] = []
            posts.reserveCapacity(detail.posts.count)
            for item in detail.posts {
                posts.append(await mapPublicPostSummary(item))
            }
            return .ok(
                .init(
                    body: .json(
                        .init(
                            id: detail.id,
                            name: detail.name,
                            excerpt: detail.excerpt,
                            content: detail.content,
                            imageURL: media?.defaultURL ?? detail.imageURL,
                            media: mapPublicMedia(media),
                            metadata: mapPublicMetadata(
                                detail.metadata,
                                title: detail.name,
                                excerpt: detail.excerpt,
                                imageURL: media?.defaultURL ?? detail.imageURL
                            ),
                            links: detail.links.map(mapPublicAuthorLink),
                            posts: posts
                        )
                    )
                )
            )
        }
        catch is Public.Author.Detail.UseCase.Error {
            return .notFound(
                .init(
                    body: .json(
                        notFoundErrorEnvelope(
                            message: "Blog author not found",
                            reason:
                                "No published blog author matches this path."
                        )
                    )
                )
            )
        }
    }
}
