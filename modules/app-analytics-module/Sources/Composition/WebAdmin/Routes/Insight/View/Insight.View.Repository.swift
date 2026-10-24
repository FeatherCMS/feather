import AnalyticsAdminAPI
import AnalyticsModule

extension Insight.View {
    enum Repository {}
}

extension Insight.View.Repository {
    protocol Interface: Sendable {
        func getOverview(
            source: String,
            from: Double,
            to: Double
        ) async throws -> Components.Schemas.AnalyticsLogOverviewSchema
    }
}
