import AnalyticsAdminAPI
import FeatherAdmin
import Foundation

protocol AdminViewAnalyticsNotFoundRepository: Sendable {

    func getOverview(
        from: Double,
        to: Double
    ) async throws
        -> AnalyticsAdminAPI.Components.Schemas.AnalyticsLogOverviewSchema
}
