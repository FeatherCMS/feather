public import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared

extension Event {
    public enum Handlers {

        public static func register(
            in events: inout EventRegistry,
            routes: Router.Routes = .standard
        ) {
            events.register(
                event: Admin.Menu.Group.Provider.self,
                context: Admin.Menu.Context.self
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
                        link: routes.admin.path,
                        permission: "system:admin:access",
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
                event: Admin.Menu.Item.Provider.self,
                context: Admin.Menu.Context.self
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
}
