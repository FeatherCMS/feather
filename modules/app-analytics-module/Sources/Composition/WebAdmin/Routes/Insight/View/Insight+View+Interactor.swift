import AnalyticsAdminAPI
import AnalyticsModule

extension Insight.View {
    enum Interactor {}
}

extension Insight.View.Interactor {
    protocol Interface: Sendable {
        func getOverview(
            source: String,
            from: Double,
            to: Double
        ) async throws -> Components.Schemas.AnalyticsLogOverviewSchema
    }
}
