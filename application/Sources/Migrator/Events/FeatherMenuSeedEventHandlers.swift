import FeatherModuleKit
import WebModule

enum FeatherMenuSeedEventHandlers {
    static func register(
        in events: inout EventRegistry
    ) {
        events.register(
            event: MenuItem.Provider.self,
            context: WebModule.Event.Context.self
        ) { event, _ in
            guard event.menuKey == "main" else { return [] }
            return [
                .init(
                    label: "Categories",
                    url: "/news/categories/",
                    priority: 45
                ),
                .init(
                    label: "Admin",
                    url: "/admin/",
                    priority: 90,
                    permission: "system:admin:access",
                    authentication: .authenticated
                ),
                .init(
                    label: "Sign In",
                    url: "/login/?redirect=/admin/",
                    priority: 100,
                    authentication: .anonymous
                ),
                .init(
                    label: "Sign Out",
                    url: "/logout/",
                    priority: 110,
                    authentication: .authenticated
                ),
            ]
        }
    }
}
