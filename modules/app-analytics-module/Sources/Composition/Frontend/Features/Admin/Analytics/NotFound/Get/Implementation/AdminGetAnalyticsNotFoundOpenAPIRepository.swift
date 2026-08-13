import AnalyticsAdminAPI
import FeatherAdmin
import Foundation
import NIOCore
import OpenAPIRuntime

struct AdminGetAnalyticsNotFoundOpenAPIRepository:
    AdminGetAnalyticsNotFoundRepository
{
    let api: AnalyticsAdminAPIClient

    func getOverview(
        from: Double,
        to: Double
    ) async throws
        -> AnalyticsAdminAPI.Components.Schemas.AnalyticsLogOverviewSchema
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.analyticsLogOverview(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        source: "web_app",
                        from: from,
                        to: to
                    )
                )
            )

            switch response {
            case .ok(let okResponse):
                return try okResponse.body.json
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to view analytics-not-found insights."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot access analytics-not-found insights."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
