import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import SystemAdminAPI
import SystemModule

extension Variable.Remove.Repository {
    struct OpenAPI:
        Variable.Remove.Repository.Interface
    {
        let api: API.Client

        func delete(
            ids: [String]
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.systemVariableDelete(
                    body: .json(.init(ids: ids))
                )
                switch response {
                case .noContent:
                    return
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
