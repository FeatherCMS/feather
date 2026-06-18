import AdminOpenAPI
import Foundation
import NIOCore

struct AdminGetAnalyticsInsightsOpenAPIRepository:
    AdminGetAnalyticsInsightsRepository
{
    let api: AdminAPI

    func getOverview(
        source: String,
        from: Double,
        to: Double
    ) async throws -> Components.Schemas.AnalyticsLogOverviewSchema {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.analyticsLogOverview(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        source: source,
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
                    message: "Please sign in again to view analytics insights."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access analytics insights."
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
