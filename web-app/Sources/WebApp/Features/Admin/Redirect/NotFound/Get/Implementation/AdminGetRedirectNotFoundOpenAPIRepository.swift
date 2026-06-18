import AdminOpenAPI
import NIOCore

struct AdminGetRedirectNotFoundOpenAPIRepository:
    AdminGetRedirectNotFoundRepository
{
    let api: AdminAPI

    func getOverview(
        from: Double,
        to: Double
    ) async throws -> Components.Schemas.AnalyticsLogOverviewSchema {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.redirectNotFoundOverview(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        source: AdminAnalyticsInsightsPage.Source.web.rawValue,
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
                        "Please sign in again to view redirect-not-found insights."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot access redirect-not-found insights."
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
