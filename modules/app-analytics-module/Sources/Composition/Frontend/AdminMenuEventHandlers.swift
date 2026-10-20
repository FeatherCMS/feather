import FeatherAdmin
public import FeatherModuleKit
import SystemModule
import SystemModuleWebAdmin

public enum AnalyticsAdminMenuEventHandlers {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: SystemModuleWebAdmin.Events.Menu.Provider.self,
            context: SystemModuleWebAdmin.Events.Context.self
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
            event: SystemModuleWebAdmin.Events.MenuItem.Provider.self,
            context: SystemModuleWebAdmin.Events.Context.self
        ) { event, _ in
            guard event.menuKey == "analytics" else { return [] }
            return [
                .init(
                    menuKey: "analytics",
                    label: "Web",
                    icon: "monitor",
                    link: "/admin/analytics/web/",
                    permission: "analytics:insights:list"
                ),
                .init(
                    menuKey: "analytics",
                    label: "API",
                    icon: "server",
                    link: "/admin/analytics/api/",
                    permission: "analytics:insights:list"
                ),
                .init(
                    menuKey: "analytics",
                    label: "Logs",
                    icon: "activity",
                    link: "/admin/analytics/logs/",
                    permission: "analytics:logs:list"
                ),
                .init(
                    menuKey: "analytics",
                    label: "404s",
                    icon: "alertCircle",
                    link: "/admin/analytics/not-found/",
                    permission: "analytics:not-found:list"
                ),
            ]
        }
    }
}
