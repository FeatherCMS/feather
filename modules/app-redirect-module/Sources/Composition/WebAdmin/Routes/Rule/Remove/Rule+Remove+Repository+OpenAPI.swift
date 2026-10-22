import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime
import RedirectAdminAPI
import RedirectApplication
import RedirectModule

extension Rule.Remove.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func delete(ids: [String]) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.redirectRuleRemove(
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
