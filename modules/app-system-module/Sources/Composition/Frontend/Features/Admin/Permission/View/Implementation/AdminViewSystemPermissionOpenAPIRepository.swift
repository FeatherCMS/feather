import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import SystemAdminAPI

struct AdminViewSystemPermissionOpenAPIRepository:
    AdminViewSystemPermissionRepository
{
    let api: SystemAdminAPIClient

    func get(
        id: String
    ) async throws -> SystemPermissionDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .systemPermissionGet(
                    path: .init(systemPermissionId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
            switch response {
            case .ok(let okResponse):
                let permission = try okResponse.body.json
                return .init(
                    id: permission.id,
                    key: permission.key,
                    name: permission.name,
                    notes: permission.notes
                )
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
