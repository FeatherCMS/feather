import FeatherWebAdmin
import WebDomain
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI

extension WebDomain.Menu.Edit.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func load(
            id: String
        ) async throws -> MenuDetailsModel {
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

        func update(
            id: String,
            input: MenuFormInput
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.menuUpdate(
                    path: .init(menuId: id),
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            key: input.normalizedKey,
                            name: input.normalizedName,
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
