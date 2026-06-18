import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminEditBlogAuthorLinkOpenAPIRepository:
    AdminEditBlogAuthorLinkRepository
{
    let api: AdminAPI

    func load(
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
                        "Your account cannot edit blog author links."
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
        menuId: String,
        id: String,
        input: BlogAuthorLinkFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogAuthorLinkUpdate(
                path: .init(blogAuthorId: menuId, blogAuthorLinkId: id),
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        label: input.normalizedLabel,
                        url: input.normalizedURL,
                        priority: input.parsedPriority ?? 0,
                        isBlank: input.isBlank.value,
                        permission: input.normalizedPermission,
                        notes: input.normalizedNotes
                    )
                )
            )
            switch response {
            case .ok:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Blog author link not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to update this blog author link."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot edit blog author links."
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
