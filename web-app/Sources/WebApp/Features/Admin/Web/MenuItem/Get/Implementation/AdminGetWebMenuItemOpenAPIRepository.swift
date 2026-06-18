import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminGetWebMenuItemOpenAPIRepository: AdminGetWebMenuItemRepository {
    let api: AdminAPI

    func get(
        menuId: String,
        id: String
    ) async throws -> WebMenuItemDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .webMenuItemGet(
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
                        "Your account cannot access web menu items."
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
