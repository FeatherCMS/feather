import AnalyticsAdminAPI
import FeatherAdmin
import Foundation

struct AdminGetAnalyticsNotFoundDefaultInteractor:
    AdminGetAnalyticsNotFoundInteractor
{
    let repository: any AdminGetAnalyticsNotFoundRepository

    func getOverview(
        from: Double,
        to: Double
    ) async throws
        -> AnalyticsAdminAPI.Components.Schemas.AnalyticsLogOverviewSchema
    {
        try await repository.getOverview(from: from, to: to)
    }
}
