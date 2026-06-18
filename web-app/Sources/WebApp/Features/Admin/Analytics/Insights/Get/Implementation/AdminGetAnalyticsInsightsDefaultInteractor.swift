import AdminOpenAPI

struct AdminGetAnalyticsInsightsDefaultInteractor:
    AdminGetAnalyticsInsightsInteractor
{
    let repository: any AdminGetAnalyticsInsightsRepository

    func getOverview(
        source: String,
        from: Double,
        to: Double
    ) async throws -> Components.Schemas.AnalyticsLogOverviewSchema {
        try await repository.getOverview(
            source: source,
            from: from,
            to: to
        )
    }
}
