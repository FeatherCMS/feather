import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime
import UserAdminAPI
import UserModule

extension Identity.Add.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func create(
            payload: Identity.Add.FormPayload
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .userIdentityPost(
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(
                            .init(
                                name: payload.name,
                                status: .init(rawValue: payload.status)
                                    ?? .invited,
                                roleIds: payload.roleIds
                            )
                        )
                    )
                switch response {
                case .created:
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
