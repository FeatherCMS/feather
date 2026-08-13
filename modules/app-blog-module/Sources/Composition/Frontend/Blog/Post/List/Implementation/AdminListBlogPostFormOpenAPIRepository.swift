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
import WebStandards

struct AdminListBlogPostFormOpenAPIRepository {
    let api: BlogAdminAPIClient

    func load(
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
                    message: "Please sign in again to load blog posts."
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

    func update(
        id: String,
        input: BlogPostFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogPostUpdate(
                path: .init(blogPostId: id),
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        title: input.normalizedTitle,
                        excerpt: input.normalizedExcerpt,
                        content: input.normalizedContent,
                        imageAssetId: input.normalizedImageAssetId,
                        authorIds: input.normalizedAuthorIds,
                        tagIds: input.normalizedTagIds,
                    )
                )
            )
            switch response {
            case .ok:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Blog post not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to update this blog post."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot edit blog posts."
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
