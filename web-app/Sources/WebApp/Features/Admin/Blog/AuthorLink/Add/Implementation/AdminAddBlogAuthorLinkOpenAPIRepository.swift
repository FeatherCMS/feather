import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminAddBlogAuthorLinkOpenAPIRepository: AdminAddBlogAuthorLinkRepository
{
    let api: AdminAPI

    func create(
        menuId: String,
        input: BlogAuthorLinkFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.blogAuthorLinkCreate(
                path: .init(blogAuthorId: menuId),
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
            case .created:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to create this blog author link."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot create blog author links."
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
