import AnalyticsModule

extension NotFound.View {
    enum Repository {}
}

extension NotFound.View.Repository {
    protocol Interface: Sendable {
        func getOverview(
            from: Double,
            to: Double
        ) async throws -> Overview.Model
    }
}
