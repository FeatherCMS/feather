import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebComponents
import WebBuilders

struct AdminRemoveBlogPostOpenAPIRepository:
    AdminRemoveBlogPostRepository
{
    let api: BlogAdminAPIClient

    func get(
        id: String
    ) async throws -> BlogPostDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogPostGet(
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
                    message: "Your account cannot delete blog posts."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func delete(
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.blogPostDelete(
                body: .json(.init(ids: [id], results: false, summary: true))
            )
        }
    }

    private func loadImageAsset(
        assetId: String?
    ) async throws -> AdminMediaAssetReferenceModel? {
        try await api.withOpenAPIRepositoryErrorMapping {
            client -> AdminMediaAssetReferenceModel? in
            guard let assetId, !assetId.isEmpty else {
                return nil as AdminMediaAssetReferenceModel?
            }
            guard
                let asset = try? await AdminMediaAssetOpenAPIRepository(
                    api: api
                )
                .getAsset(id: assetId)
            else {
                return nil as AdminMediaAssetReferenceModel?
            }
            return .init(schema: asset)
        }
    }
}
