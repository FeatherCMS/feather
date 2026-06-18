import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminGetBlogAuthorOpenAPIRepository: AdminGetBlogAuthorRepository {
    let api: AdminAPI

    func get(
        id: String
    ) async throws -> BlogAuthorDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            async let authorResponse =
                client
                .blogAuthorGet(
                    path: .init(blogAuthorId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
            async let linksResponse =
                client
                .blogAuthorLinkSearch(
                    path: .init(blogAuthorId: id),
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(size: 100, number: 1),
                            filters: .init(search: nil)
                        )
                    )
                )
            let response = try await authorResponse
            switch response {
            case .ok(let okResponse):
                let author = try okResponse.body.json
                let items: [Components.Schemas.BlogAuthorLinkListItemSchema]
                switch try await linksResponse {
                case .ok(let linksOk):
                    items = try linksOk.body.json.data.items
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized(
                        message:
                            "Please sign in again to load blog author links."
                    )
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden(
                        message:
                            "Your account cannot access blog author links."
                    )
                case .undocumented(let statusCode, let undocumentedResponse):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: undocumentedResponse.body
                    )
                }
                return .init(
                    id: author.id,
                    name: author.name,
                    excerpt: author.excerpt,
                    content: author.content,
                    profileImageAssetId: author.profileImageAssetId,
                    profileImage: try await loadProfileImage(
                        assetId: author.profileImageAssetId
                    ),
                    metadata: AdminMetadataSchemaBuilder.formValue(
                        from: author.metadata,
                        fallbackTitle: author.name,
                        fallbackExcerpt: author.excerpt
                    ),
                    items: items
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
