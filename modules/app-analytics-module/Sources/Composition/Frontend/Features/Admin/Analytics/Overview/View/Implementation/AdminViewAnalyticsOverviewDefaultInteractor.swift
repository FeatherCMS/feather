struct AdminViewAnalyticsOverviewDefaultInteractor:
    AdminViewAnalyticsOverviewInteractor
{
    func getOverview() async throws -> AdminViewAnalyticsOverviewModel {
        .init(title: "Analytics module")
    }
}
