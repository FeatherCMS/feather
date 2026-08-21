import FeatherContracts

public struct AdminMenuCatalog: Sendable {
    public let menus: [AdminMenuDefinition]
    public let items: [AdminMenuItemDefinition]

    public init(
        menus: [AdminMenuDefinition],
        items: [AdminMenuItemDefinition]
    ) {
        self.menus = menus
        self.items = items
    }

    public static func load(
        from events: any EventPublisher
    ) async throws -> Self {
        let context = AdminEventContext(path: "", permissions: [])
        let menus =
            try await events.trigger(
                event: AdminMenuProvider(),
                using: context
            )
            .flatMap { $0 }
        var items: [AdminMenuItemDefinition] = []
        for menu in menus {
            items +=
                try await events.trigger(
                    event: AdminMenuItemProvider(menuKey: menu.key),
                    using: context
                )
                .flatMap { $0 }
        }
        return .init(menus: menus, items: items)
    }
}
