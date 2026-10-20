public import FeatherAdmin
public import FeatherModuleKit
import Hummingbird
import SystemModule

public enum AdminMenuEventHandlers {
    public static func register(
        in events: inout EventRegistry,
        routes: WebAdmin.System.Router.Routes = .standard
    ) {
        events.register(
            event: WebAdmin.Events.Menu.Provider.self,
            context: WebAdmin.Events.Context.self
        ) { _, _ in
            [
                .init(
                    key: "site",
                    groupKey: "site",
                    label: "Home",
                    icon: "globe",
                    link: "/",
                    priority: 0
                ),
                .init(
                    key: "dashboard",
                    groupKey: "admin",
                    label: "Dashboard",
                    icon: "home",
                    link: "/admin/",
                    permission: "system.admin.access",
                    priority: 0
                ),
                .init(
                    key: "system",
                    groupKey: "admin",
                    label: "System",
                    icon: "settings",
                    priority: 120
                ),
            ]
        }
        events.register(
            event: WebAdmin.Events.MenuItem.Provider.self,
            context: WebAdmin.Events.Context.self
        ) { event, _ in
            guard event.menuKey == "system" else { return [] }
            return [
                .init(
                    menuKey: "system",
                    label: "Variables",
                    icon: "sliders",
                    link: routes.root
                        .appending(pathComponent: "variables")
                        .path,
                    permission: "system:variables:list"
                ),
                .init(
                    menuKey: "system",
                    label: "Permissions",
                    icon: "lock",
                    link: routes.root
                        .appending(pathComponent: "permissions")
                        .path,
                    permission: "system:permissions:list"
                ),
                .init(
                    menuKey: "system",
                    label: "Worker jobs",
                    icon: "activity",
                    link: routes.root
                        .appending(pathComponent: "jobs")
                        .path,
                    permission: "system:jobs:list"
                ),
            ]
        }
    }
}
