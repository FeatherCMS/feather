import FeatherWebAdmin
import MediaAdminAPI
import OpenAPIRuntime

struct AdminRemoveMediaVariantOpenAPIRepository:
    AdminRemoveMediaVariantRepository
{
    let api: MediaAdminAPIClient


    func delete(ids: [String]) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.mediaVariantRemove(
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
