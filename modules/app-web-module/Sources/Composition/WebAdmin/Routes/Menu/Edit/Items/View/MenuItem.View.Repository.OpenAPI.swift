import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI
import WebModule

extension MenuItem.View.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func get(
            menuId: String,
            id: String
        ) async throws -> MenuItem.View.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .menuItemGet(
                        path: .init(menuId: menuId, menuItemId: id),
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
    }
}
