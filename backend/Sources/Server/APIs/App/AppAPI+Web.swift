import Infrastructure
import AppOpenAPI
import WebApplication

extension AppAPI {
    func webPageGet(
        _ input: Operations.WebPageGet.Input
    ) async throws -> Operations.WebPageGet.Output {
        do {
            let detail = try await modules.web.makeGetPublicPageByID()
                .execute(
                    id: input.path.id
                )
            let media = await publicMedia(assetId: detail.imageAssetId)
            return .ok(
                .init(
                    body: .json(
                        .init(
                            id: detail.id,
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
        catch is GetPublicPageByID.Error {
            return .notFound
        }
    }
}
