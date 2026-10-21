import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI
import UserModule

extension Role.Add.Repository {
    struct OpenAPI: Interface {

        let api: API.Client

        func create(
            payload: Role.Add.FormPayload
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .userRolePost(
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(
                            .init(
                                key: payload.key,
                                name: payload.name,
                                notes: payload.notes
                            )
                        )
                    )
                switch response {
                case .created:
                    return
                case .badRequest:
                    throw OpenAPIRepositoryError.failure(
                        .init(
                            statusCode: 400,
                            responseBody: nil,
                            backendError: nil
                        )
                    )
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
