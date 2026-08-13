import FeatherAdmin
import FeatherApplication
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
        let menuItems =
            try await events.trigger(
                event: AdminHomeMenuItemProvider(menuKey: "home"),
                using: context
            )
            .flatMap { $0 }

        let firstOverview = overview.first
        return .init(
            title: "Admin - Home",
            description:
                "Content overview and quick actions for the admin dashboard.",
            summary:
                "Content inventory, top pages, and quick actions across blog and web modules.",
            contentStats: overview.flatMap { $0.contentStats },
            dailyTraffic: firstOverview?.dailyTraffic,
            topPages: firstOverview?.topPages,
            webInsightCards: overview.flatMap { $0.insightCards },
            quickLinkGroups: menuItems.compactMap {
                quickLinkGroup(
                    definition: $0,
                    permissions: context.permissions
                )
            }
        )
    }

    private func quickLinkGroup(
        definition: AdminHomeMenuItemDefinition,
        permissions: Set<String>
    ) -> AdminGetHomeModel.QuickLinkGroup? {
        var actions: [AdminGetHomeModel.QuickLinkAction] = []
        if permissions.contains(definition.createPermission) {
            actions.append(
                .init(
                    label: definition.addLabel,
                    href: definition.addHref,
                    style: .primary
                )
            )
        }
        if permissions.contains(definition.listPermission) {
            actions.append(
                .init(
                    label: definition.manageLabel,
                    href: definition.manageHref,
                    style: .secondary
                )
            )
        }
        guard !actions.isEmpty else { return nil }
        return .init(label: definition.label, actions: actions)
    }
}
