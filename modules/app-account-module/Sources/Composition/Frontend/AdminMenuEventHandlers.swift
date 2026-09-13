import FeatherAdmin
import FeatherContracts
import SystemContracts

public enum AccountAdminMenuEventHandlers {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: AdminMenuProvider.self,
            context: AdminEventContext.self
        ) { _, _ in
            [
                .init(
                    key: "account",
                    groupKey: "admin",
                    label: "Account",
                    icon: "user",
                    priority: 90
                )
            ]
        }
        events.register(
            event: AdminMenuItemProvider.self,
            context: AdminEventContext.self
        ) { event, _ in
            guard event.menuKey == "account" else { return [] }
            return [
                .init(
                    menuKey: "account",
                    label: "Profile",
                    icon: "user",
                    link: "/admin/account/profile/",
                    permission: "account:profile:read"
                ),
                .init(
                    menuKey: "account",
                    label: "Invitations",
                    icon: "mail",
                    link: "/admin/account/invitations/",
                    permission: "account:invitations:list"
                ),
            ]
        }
    }
}
