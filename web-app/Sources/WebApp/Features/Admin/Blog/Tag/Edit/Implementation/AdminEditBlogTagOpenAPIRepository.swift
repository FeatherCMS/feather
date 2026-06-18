import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminEditBlogTagOpenAPIRepository: AdminEditBlogTagRepository {
    let api: AdminAPI

    func load(
        id: String
    ) async throws -> BlogTagDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogTagGet(
                path: .init(blogTagId: id),
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
                    )
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Blog tag not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to load this blog tag."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access blog tags."
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
        input: BlogTagFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogTagUpdate(
                path: .init(blogTagId: id),
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        title: input.normalizedTitle,
                        excerpt: input.normalizedExcerpt,
                        content: input.normalizedContent,
                        imageAssetId: input.normalizedImageAssetId,
                        metadata: AdminMetadataSchemaBuilder.createSchema(
                            input: input.metadataValue
                        )
                    )
                )
            )
            switch response {
            case .ok:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Blog tag not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to update this blog tag."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot edit blog tags."
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
