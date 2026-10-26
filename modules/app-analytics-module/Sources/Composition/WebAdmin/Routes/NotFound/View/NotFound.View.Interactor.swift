import AnalyticsModule

extension NotFound.View {
    enum Interactor {}
}

extension NotFound.View.Interactor {
    protocol Interface: Sendable {
        func getOverview(
            from: Double,
            to: Double
        ) async throws -> Overview.Model
    }
}
