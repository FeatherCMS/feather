public import FeatherModuleKit

public struct AdminMenuCatalog: Sendable {
    public let menus: [WebAdmin.Events.Menu.Definition]
    public let items: [WebAdmin.Events.MenuItem.Definition]

    public init(
        menus: [WebAdmin.Events.Menu.Definition],
        items: [WebAdmin.Events.MenuItem.Definition]
    ) {
        self.menus = menus
        self.items = items
    }

    public static func load(
        from events: any EventPublisher
    ) async throws -> Self {
        let context = WebAdmin.Events.Context(path: "", permissions: [])
        let menus =
            try await events.trigger(
                event: WebAdmin.Events.Menu.Provider(),
                using: context
            )
            .flatMap { $0 }
        var items: [WebAdmin.Events.MenuItem.Definition] = []
        for menu in menus {
            items +=
                try await events.trigger(
                    event: WebAdmin.Events.MenuItem.Provider(menuKey: menu.key),
                    using: context
                )
                .flatMap { $0 }
        }
        return .init(menus: menus, items: items)
    }
}
