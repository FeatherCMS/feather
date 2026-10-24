import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI
import WebDomain
import WebModule

extension WebModule.Menu.Remove.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func get(
            id: String
        ) async throws -> WebModule.Menu.View.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.menuGet(
                    path: .init(menuId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
                switch response {
                case .ok(let okResponse):
                    let menu = try okResponse.body.json
                    return .init(
                        id: menu.id,
                        key: menu.key,
                        name: menu.name,
                        notes: menu.notes
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
            id: String
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                _ = try await client.menuRemove(
                    body: .json(.init(ids: [id]))
                )
            }
        }
    }
}
