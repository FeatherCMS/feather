import FeatherAdmin
import OpenAPIRuntime
import SystemAdminAPI

struct AdminListSystemJobOpenAPIRepository: AdminListSystemJobRepository {
    let api: SystemAdminAPIClient

    func list() async throws -> [Components.Schemas.SystemJobSchema] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.systemJobList(
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let value):
                return try value.body.json
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
