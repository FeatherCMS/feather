public import WebAppAPI
import WebApplication

extension AppAPIGateway {
    public func pageGet(
        _ input: Operations.PageGet.Input
    ) async throws -> Operations.PageGet.Output {
        do {
            let detail = try await useCases.makeGetPublicPageByID()
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
        catch is Public.Page.Detail.UseCase.Error {
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
}
