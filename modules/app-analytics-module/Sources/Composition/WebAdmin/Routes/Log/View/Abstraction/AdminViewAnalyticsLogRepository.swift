import AnalyticsAdminAPI

protocol AdminViewAnalyticsLogRepository: Sendable {

    func get(
        id: String
    ) async throws -> Components.Schemas.AnalyticsLogDetailSchema
}
