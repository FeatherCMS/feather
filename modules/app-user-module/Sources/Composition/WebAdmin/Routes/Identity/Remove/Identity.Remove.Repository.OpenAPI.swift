import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI
import UserModule

extension Identity.Remove.Repository {
    struct OpenAPI:
        Interface
    {
        let api: API.Client

        private func exists(
            id: String
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.userIdentityGet(
                    path: .init(userIdentityId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
                switch response {
                case .ok(let okResponse):
                    _ = try okResponse.body.json
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
                let response = try await client.userIdentityDelete(
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
