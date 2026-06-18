import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminRemoveBlogAuthorLinkOpenAPIRepository:
    AdminRemoveBlogAuthorLinkRepository
{
    let api: AdminAPI

    func get(
        menuId: String,
        id: String
    ) async throws -> BlogAuthorLinkDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogAuthorLinkGet(
                path: .init(blogAuthorId: menuId, blogAuthorLinkId: id),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let okResponse):
                let item = try okResponse.body.json
                return .init(
                    id: item.id,
                    menuId: item.menuId,
                    label: item.label,
                    url: item.url,
                    priority: item.priority,
                    isBlank: item.isBlank,
                    permission: item.permission,
                    notes: item.notes
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Blog author link not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to load this blog author link."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot delete blog author links."
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
        menuId: String,
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogAuthorLinkDelete(
                path: .init(blogAuthorId: menuId, blogAuthorLinkId: id)
            )
            switch response {
            case .noContent:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Blog author link not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to delete this blog author link."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot delete blog author links."
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
