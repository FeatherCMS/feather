import FeatherModuleKit
import FeatherWebAdmin
import SystemModule

extension Dashboard.Interactor {
    struct Default: Interface {
        let events: any EventPublisher

        func getHome(
            context: Dashboard.Event.Context
        ) async throws -> Dashboard.Model {
            let overview =
                try await events.trigger(
                    event: Dashboard.Event.Provider(),
                    using: context
                )
                .flatMap { $0 }
            let firstOverview = overview.first {
                $0.dailyTraffic != nil
                    || $0.topPages != nil
                    || !$0.insightCards.isEmpty
            }
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
}
