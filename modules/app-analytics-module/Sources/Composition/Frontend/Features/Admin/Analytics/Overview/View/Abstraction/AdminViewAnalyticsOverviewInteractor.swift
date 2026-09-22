
protocol AdminViewAnalyticsOverviewInteractor: Sendable {

    func getOverview() async throws -> AdminViewAnalyticsOverviewModel
}
