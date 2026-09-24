import AnalyticsAdminAPI
import FeatherAdmin
import OpenAPIRuntime

struct AdminViewAnalyticsLogOpenAPIRepository: AdminViewAnalyticsLogRepository {
    let api: AnalyticsAdminAPIClient
    private let unauthorizedMessage =
        "Please sign in again to load this analytics log."

    init(api: AnalyticsAdminAPIClient) {
        self.api = api
    }

    func get(
        id: String
    ) async throws -> Components.Schemas.AnalyticsLogDetailSchema {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.analyticsLogGet(
                path: .init(id: id),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let okResponse):
                return try okResponse.body.json
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
