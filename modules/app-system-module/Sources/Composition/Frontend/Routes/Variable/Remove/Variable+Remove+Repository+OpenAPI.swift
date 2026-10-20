import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import SystemAdminAPI
import SystemModule

extension WebAdmin.System.Variable.Remove.Repository {
    struct OpenAPI:
        WebAdmin.System.Variable.Remove.Repository.Interface
    {
        let api: SystemAdminAPIClient

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
