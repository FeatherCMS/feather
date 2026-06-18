import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminGetAnalyticsLogOpenAPIRepository: AdminGetAnalyticsLogRepository {
    let api: AdminAPI
    private let unauthorizedMessage =
        "Please sign in again to load this analytics log."

    init(api: AdminAPI) {
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
                throw OpenAPIRepositoryError.notFound(
                    message: "Analytics log not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: unauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access analytics logs."
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
