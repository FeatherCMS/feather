import AnalyticsAdminAPI
import FeatherAdmin
import Foundation

protocol AdminViewAnalyticsNotFoundInteractor: Sendable {

    func getOverview(
        from: Double,
        to: Double
    ) async throws
        -> AnalyticsAdminAPI.Components.Schemas.AnalyticsLogOverviewSchema
}
