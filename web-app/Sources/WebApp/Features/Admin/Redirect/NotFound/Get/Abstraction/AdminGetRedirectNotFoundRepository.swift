import AdminOpenAPI

protocol AdminGetRedirectNotFoundRepository: Sendable {

    func getOverview(
        from: Double,
        to: Double
    ) async throws -> Components.Schemas.AnalyticsLogOverviewSchema
}
