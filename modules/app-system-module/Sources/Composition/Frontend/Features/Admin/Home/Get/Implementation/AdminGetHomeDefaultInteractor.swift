import FeatherAdmin
import FeatherContracts

struct AdminGetHomeDefaultInteractor: AdminGetHomeInteractor {
    let events: any EventPublisher

    func getHome(
        context: AdminDashboardEventContext
    ) async throws -> AdminGetHomeModel {
        let overview =
            try await events.trigger(
                event: AdminHomeOverviewProvider(),
                using: context
            )
            .flatMap { $0 }
        let firstOverview = overview.first
        return .init(
            title: "Admin - Home",
            description:
                "Content overview for the admin dashboard.",
            summary:
                "Content inventory and top pages across blog and web modules.",
            contentStats: overview.flatMap { $0.contentStats },
            dailyTraffic: firstOverview?.dailyTraffic,
            topPages: firstOverview?.topPages,
            webInsightCards: overview.flatMap { $0.insightCards }
        )
    }
}
