import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

extension Email.Remove.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func get(
            id: String
        ) async throws -> Email.View.Detail {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .authEmailGet(
                        path: .init(authEmailId: id),
                        headers: .init(accept: [.init(contentType: .json)])
                    )
                switch response {
                case .ok(let ok):
                    let item = try ok.body.json
                    return .init(
                        id: item.id,
                        identityId: item.identityId,
                        email: item.email
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
                _ = try await client.authEmailRemove(
                    body: .json(.init(ids: [id]))
                )
            }
        }
    }
}
