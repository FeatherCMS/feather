import FeatherAdmin
import FeatherContracts
import Hummingbird
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
                    link: AccountAdminRoutes.profile.description + "/",
                    permission: "account:profile:read"
                ),
                .init(
                    menuKey: "account",
                    label: "Settings",
                    icon: "settings",
                    link: AccountAdminRoutes.settings.description + "/",
                    permission: "account:settings:read"
                ),
                .init(
                    menuKey: "account",
                    label: "Invitations",
                    icon: "mail",
                    link: AccountAdminRoutes.invitations.description + "/",
                    permission: "account:invitations:list"
                ),
            ]
        }
    }
}
