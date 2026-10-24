import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI
import WebModule

extension MenuItem.Edit.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func load(
            menuId: String,
            id: String
        ) async throws -> MenuItem.View.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.menuItemGet(
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

        func update(
            menuId: String,
            id: String,
            input: MenuItem.Form.Input
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.menuItemUpdate(
                    path: .init(menuId: menuId, menuItemId: id),
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            label: input.normalizedLabel,
                            url: input.normalizedURL,
                            priority: input.parsedPriority ?? 0,
                            isBlank: input.isBlank.value,
                            permission: input.permission,
                            authentication: input.normalizedAuthentication,
                            notes: input.normalizedNotes
                        )
                    )
                )
                switch response {
                case .ok:
                    return
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
