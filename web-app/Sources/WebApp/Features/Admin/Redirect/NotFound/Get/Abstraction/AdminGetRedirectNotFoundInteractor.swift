import AdminOpenAPI

protocol AdminGetRedirectNotFoundInteractor: Sendable {

    func getOverview(
        from: Double,
        to: Double
    ) async throws -> Components.Schemas.AnalyticsLogOverviewSchema
}
