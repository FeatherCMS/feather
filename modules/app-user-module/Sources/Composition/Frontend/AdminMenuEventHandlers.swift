import FeatherAdmin
import FeatherContracts
import SystemContracts

public enum UserAdminMenuEventHandlers {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: AdminMenuProvider.self,
            context: AdminEventContext.self
        ) { _, _ in
            [
                .init(
                    key: "user",
                    groupKey: "admin",
                    label: "User",
                    icon: "users",
                    priority: 100
                )
            ]
        }
        events.register(
            event: AdminMenuItemProvider.self,
            context: AdminEventContext.self
        ) { event, _ in
            guard event.menuKey == "user" else { return [] }
            return [
                .init(
                    menuKey: "user",
                    label: "Identities",
                    icon: "users",
                    link: "/admin/user/identities/",
                    permission: "user:identities:list"
                ),
                .init(
                    menuKey: "user",
                    label: "Roles",
                    icon: "users",
                    link: "/admin/user/roles/",
                    permission: "user:roles:list"
                ),
            ]
        }
    }
}
