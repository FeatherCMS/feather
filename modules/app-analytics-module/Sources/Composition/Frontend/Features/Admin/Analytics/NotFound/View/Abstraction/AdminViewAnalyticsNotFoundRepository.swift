import AnalyticsAdminAPI

protocol AdminViewAnalyticsNotFoundRepository: Sendable {

    func getOverview(
        from: Double,
        to: Double
    ) async throws
        -> AnalyticsAdminAPI.Components.Schemas.AnalyticsLogOverviewSchema
}
