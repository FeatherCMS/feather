import AnalyticsAdminAPI
import FeatherAdmin

protocol AdminViewAnalyticsNotFoundInteractor: Sendable {

    func getOverview(
        from: Double,
        to: Double
    ) async throws
        -> AnalyticsAdminAPI.Components.Schemas.AnalyticsLogOverviewSchema
}
