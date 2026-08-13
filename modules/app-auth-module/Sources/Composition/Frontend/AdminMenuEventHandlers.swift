import FeatherAdmin
import FeatherContracts
import SystemApplication

public enum AuthAdminMenuEventHandlers {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: AdminMenuProvider.self,
            context: AdminEventContext.self
        ) { _, _ in
            [
                .init(
                    key: "auth",
                    groupKey: "admin",
                    label: "Auth",
                    icon: "shield",
                    priority: 90
                )
            ]
        }
        events.register(
            event: AdminMenuItemProvider.self,
            context: AdminEventContext.self
        ) { event, _ in
            guard event.menuKey == "auth" else { return [] }
            return [
                .init(
                    menuKey: "auth",
                    label: "Access Control",
                    icon: "key",
                    link: "/admin/auth/access-control/",
                    permission: "auth:access-control:list"
                ),
                .init(
                    menuKey: "auth",
                    label: "Roles",
                    icon: "users",
                    link: "/admin/user/roles/",
                    permission: "user:roles:list"
                ),
                .init(
                    menuKey: "auth",
                    label: "Magic links",
                    icon: "link",
                    link: "/admin/auth/magic-links/",
                    permission: "auth:magic-links:list"
                ),
                .init(
                    menuKey: "auth",
                    label: "Credentials",
                    icon: "key",
                    link: "/admin/auth/credentials/",
                    permission: "auth:credentials:list"
                ),
            ]
        }
    }
}
