import FeatherAdmin
import FeatherContracts

public enum AdminMenuEventHandlers {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: AdminMenuProvider.self,
            context: AdminEventContext.self
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
            event: AdminMenuItemProvider.self,
            context: AdminEventContext.self
        ) { event, _ in
            guard event.menuKey == "system" else { return [] }
            return [
                .init(
                    menuKey: "system",
                    label: "Variables",
                    icon: "sliders",
                    link: "/admin/system/variables/",
                    permission: "system:variables:list"
                ),
                .init(
                    menuKey: "system",
                    label: "Permissions",
                    icon: "lock",
                    link: "/admin/system/permissions/",
                    permission: "system:permissions:list"
                ),
                .init(
                    menuKey: "system",
                    label: "Worker jobs",
                    icon: "activity",
                    link: "/admin/system/jobs/",
                    permission: "system:jobs:list"
                ),
            ]
        }
    }
}
