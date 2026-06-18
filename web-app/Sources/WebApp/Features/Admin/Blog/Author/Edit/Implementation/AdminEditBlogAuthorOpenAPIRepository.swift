import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminEditBlogAuthorOpenAPIRepository: AdminEditBlogAuthorRepository {
    let api: AdminAPI

    func load(
        id: String
    ) async throws -> BlogAuthorDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogAuthorGet(
                path: .init(blogAuthorId: id),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let okResponse):
                let menu = try okResponse.body.json
                return .init(
                    id: menu.id,
                    name: menu.name,
                    excerpt: menu.excerpt,
                    content: menu.content,
                    profileImageAssetId: menu.profileImageAssetId,
                    profileImage: try await loadProfileImage(
                        assetId: menu.profileImageAssetId
                    ),
                    metadata: AdminMetadataSchemaBuilder.formValue(
                        from: menu.metadata,
                        fallbackTitle: menu.name,
                        fallbackExcerpt: menu.excerpt
                    ),
                    items: []
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Blog author not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to load this blog author."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot access blog authors."
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
        input: BlogAuthorFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogAuthorUpdate(
                path: .init(blogAuthorId: id),
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        name: input.normalizedName,
                        excerpt: input.normalizedExcerpt,
                        content: input.normalizedContent,
                        profileImageAssetId: input
                            .normalizedProfileImageAssetId,
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
                    message: "Blog author not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to update this blog author."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot edit blog authors."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    private func loadProfileImage(
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
