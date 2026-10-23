import AnalyticsAdminAPI
import AnalyticsModule
import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime

extension Log.View.Repository {
    struct OpenAPI: Interface {
        let api: AnalyticsAdminAPIClient

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
}
