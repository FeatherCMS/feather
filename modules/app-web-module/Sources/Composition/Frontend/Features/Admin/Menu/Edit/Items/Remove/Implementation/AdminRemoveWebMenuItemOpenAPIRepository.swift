import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI

struct AdminRemoveWebMenuItemOpenAPIRepository:
    AdminRemoveWebMenuItemRepository
{
    let api: WebAdminAPIClient

    func get(
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
                    authentication: item.authentication,
                    notes: item.notes
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden
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
            _ = try await client.webMenuItemRemove(
                path: .init(webMenuId: menuId),
                body: .json(.init(ids: [id], results: false, summary: true))
            )
        }
    }
}
