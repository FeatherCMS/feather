import AnalyticsAdminAPI
import AnalyticsModule

extension Insight.View.Interactor {
    struct Default: Interface {
        let repository: any Insight.View.Repository.Interface

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
}
