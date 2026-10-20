import FeatherWebAdmin
import OpenAPIRuntime
import UserAdminAPI
import UserModule

extension Role.Remove.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        private func name(
            id: String
        ) async throws -> String {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .userRoleGet(
                        path: .init(userRoleId: id),
                        headers: .init(accept: [.init(contentType: .json)])
                    )
                switch response {
                case .ok(let ok):
                    let item = try ok.body.json
                    return item.name ?? id
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
            ids: [String]
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.userRoleDelete(
                    body: .json(.init(ids: ids))
                )
                switch response {
                case .noContent: return
                case .unauthorized: throw OpenAPIRepositoryError.unauthorized
                case .forbidden: throw OpenAPIRepositoryError.forbidden
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
