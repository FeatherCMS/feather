public import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import SystemModule
import SystemWebAdmin

extension Event {
    public enum Handlers {
        public static func registerMenu(in events: inout EventRegistry) {
            events.register(
                event: SystemWebAdmin.Admin.Menu.Group.Provider.self,
                context: SystemWebAdmin.Admin.Menu.Context.self
            ) { _, _ in
                [
                    .init(
                        key: "analytics",
                        groupKey: "admin",
                        label: "Analytics",
                        icon: "barChart2",
                        priority: 10
                    )
                ]
            }
            events.register(
                event: SystemWebAdmin.Admin.Menu.Item.Provider.self,
                context: SystemWebAdmin.Admin.Menu.Context.self
            ) { event, _ in
                guard event.menuKey == "analytics" else { return [] }
                return [
                    .init(
                        menuKey: "analytics",
                        label: "Web",
                        icon: "monitor",
                        link: Router.Routes.web.path,
                        permission: "analytics:insights:list"
                    ),
                    .init(
                        menuKey: "analytics",
                        label: "API",
                        icon: "server",
                        link: Router.Routes.api.path,
                        permission: "analytics:insights:list"
                    ),
                    .init(
                        menuKey: "analytics",
                        label: "Logs",
                        icon: "activity",
                        link: Router.Routes.logs.path,
                        permission: "analytics:logs:list"
                    ),
                    .init(
                        menuKey: "analytics",
                        label: "404s",
                        icon: "alertCircle",
                        link: Router.Routes.notFound.path,
                        permission: "analytics:not-found:list"
                    ),
                ]
            }
        }
    }
}
