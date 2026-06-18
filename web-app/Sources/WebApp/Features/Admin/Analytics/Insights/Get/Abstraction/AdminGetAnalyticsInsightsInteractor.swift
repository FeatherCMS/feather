import AdminOpenAPI

protocol AdminGetAnalyticsInsightsInteractor: Sendable {
    func getOverview(
        source: String,
        from: Double,
        to: Double
    ) async throws -> Components.Schemas.AnalyticsLogOverviewSchema
}
