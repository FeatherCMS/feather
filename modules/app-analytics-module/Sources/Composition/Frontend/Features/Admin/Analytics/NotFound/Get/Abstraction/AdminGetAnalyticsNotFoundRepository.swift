import AnalyticsAdminAPI
import FeatherAdmin
import Foundation

protocol AdminGetAnalyticsNotFoundRepository: Sendable {

    func getOverview(
        from: Double,
        to: Double
    ) async throws
        -> AnalyticsAdminAPI.Components.Schemas.AnalyticsLogOverviewSchema
}
