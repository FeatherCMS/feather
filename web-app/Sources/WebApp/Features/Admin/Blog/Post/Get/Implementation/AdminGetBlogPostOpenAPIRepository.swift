import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminGetBlogPostOpenAPIRepository: AdminGetBlogPostRepository {
    let api: AdminAPI

    func get(
        id: String
    ) async throws -> BlogPostDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .blogPostGet(
                    path: .init(blogPostId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
            switch response {
            case .ok(let okResponse):
                let page = try okResponse.body.json
                return .init(
                    id: page.id,
                    title: page.title,
                    excerpt: page.excerpt,
                    content: page.content,
                    imageAssetId: page.imageAssetId,
                    imageAsset: try await loadImageAsset(
                        assetId: page.imageAssetId
                    ),
                    metadata: AdminMetadataSchemaBuilder.formValue(
                        from: page.metadata,
                        fallbackTitle: page.title,
                        fallbackExcerpt: page.excerpt
                    ),
                    authorIds: Array(page.authorIds),
                    tagIds: Array(page.tagIds)
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Blog post not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to load this blog post."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access blog posts."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    private func loadImageAsset(
        assetId: String?
    ) async throws -> AdminMediaAssetReferenceModel? {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            guard let assetId, !assetId.isEmpty else {
                return nil
            }
            guard
                let asset = try? await AdminMediaAssetOpenAPIRepository(
                    api: api
                )
                .getAsset(id: assetId)
            else {
                return nil
            }
            return .init(schema: asset)
        }
    }
}
