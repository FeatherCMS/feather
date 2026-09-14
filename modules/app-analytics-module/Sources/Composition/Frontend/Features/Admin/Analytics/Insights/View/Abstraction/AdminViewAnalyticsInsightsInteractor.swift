import AnalyticsAdminAPI
import FeatherAdmin

protocol AdminViewAnalyticsInsightsInteractor: Sendable {
    func getOverview(
        source: String,
        from: Double,
        to: Double
    ) async throws -> Components.Schemas.AnalyticsLogOverviewSchema
}
