import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminEditWebMenuItemOpenAPIRepository:
    AdminEditWebMenuItemRepository
{
    let api: AdminAPI

    func load(
        menuId: String,
        id: String
    ) async throws -> WebMenuItemDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.webMenuItemGet(
                path: .init(webMenuId: menuId, webMenuItemId: id),
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
                    message: "Web menu item not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to load this web menu item."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot edit web menu items."
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
        input: WebMenuItemFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.webMenuItemUpdate(
                path: .init(webMenuId: menuId, webMenuItemId: id),
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
                    message: "Web menu item not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to update this web menu item."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot edit web menu items."
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
