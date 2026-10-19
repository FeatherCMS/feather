import SystemModule
import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import SystemAdminAPI

struct AdminRemoveSystemPermissionOpenAPIRepository:
    AdminRemoveSystemPermissionRepository
{
    let api: SystemAdminAPIClient

    func delete(
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.systemPermissionDelete(
                body: .json(.init(ids: [id]))
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
