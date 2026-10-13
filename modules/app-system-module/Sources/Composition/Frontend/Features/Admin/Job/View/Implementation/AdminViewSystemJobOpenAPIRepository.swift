import FeatherAdmin
import OpenAPIRuntime
import SystemAdminAPI

struct AdminViewSystemJobOpenAPIRepository: AdminViewSystemJobRepository {
    let api: SystemAdminAPIClient

    func get(id: String) async throws -> SystemJobDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.systemJobGet(
                path: .init(systemJobId: id),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let value):
                return .init(job: try value.body.json)
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
