import AnalyticsAdminAPI
import FeatherAdmin

protocol AdminGetAnalyticsInsightsRepository: Sendable {
    func getOverview(
        source: String,
        from: Double,
        to: Double
    ) async throws -> Components.Schemas.AnalyticsLogOverviewSchema
}
