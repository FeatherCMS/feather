import AnalyticsAdminAPI
import FeatherAdmin

struct AdminViewAnalyticsNotFoundDefaultInteractor:
    AdminViewAnalyticsNotFoundInteractor
{
    let repository: any AdminViewAnalyticsNotFoundRepository

    func getOverview(
        from: Double,
        to: Double
    ) async throws
        -> AnalyticsAdminAPI.Components.Schemas.AnalyticsLogOverviewSchema
    {
        try await repository.getOverview(from: from, to: to)
    }
}
