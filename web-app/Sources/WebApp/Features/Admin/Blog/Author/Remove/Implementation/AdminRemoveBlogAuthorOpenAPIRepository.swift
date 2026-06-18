import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminRemoveBlogAuthorOpenAPIRepository:
    AdminRemoveBlogAuthorRepository
{
    let api: AdminAPI

    func get(
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
                    profileImage: nil,
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
                        "Your account cannot delete blog authors."
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
            let response = try await client.blogAuthorDelete(
                path: .init(blogAuthorId: id)
            )
            switch response {
            case .noContent:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Blog author not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to delete this blog author."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot delete blog authors."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
