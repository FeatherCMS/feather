import AnalyticsAdminAPI
import FeatherAdmin
import Foundation

protocol AdminGetAnalyticsNotFoundInteractor: Sendable {

    func getOverview(
        from: Double,
        to: Double
    ) async throws
        -> AnalyticsAdminAPI.Components.Schemas.AnalyticsLogOverviewSchema
}
