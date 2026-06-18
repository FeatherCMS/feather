import AdminOpenAPI
import Foundation

protocol AdminGetAnalyticsLogRepository: Sendable {

    func get(
        id: String
    ) async throws -> Components.Schemas.AnalyticsLogDetailSchema
}
