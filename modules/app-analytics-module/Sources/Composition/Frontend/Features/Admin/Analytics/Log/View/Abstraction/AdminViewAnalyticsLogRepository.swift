import AnalyticsAdminAPI
import FeatherAdmin
import Foundation

protocol AdminViewAnalyticsLogRepository: Sendable {

    func get(
        id: String
    ) async throws -> Components.Schemas.AnalyticsLogDetailSchema
}
