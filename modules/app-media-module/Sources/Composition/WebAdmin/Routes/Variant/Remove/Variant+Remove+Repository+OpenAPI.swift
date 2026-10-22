import FeatherWebAdmin
import FeatherWebShared
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime

extension Variant.Remove.Repository {
    struct OpenAPI:
        Variant.Remove.Repository.Interface
    {
        let api: MediaAdminAPIClient

        func delete(ids: [String]) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.mediaVariantDelete(
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
