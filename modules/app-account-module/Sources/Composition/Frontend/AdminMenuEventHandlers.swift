import FeatherAdmin
public import FeatherModuleKit
import Hummingbird
import SystemModule
import SystemModuleWebAdmin

public enum AccountAdminMenuEventHandlers {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: SystemModuleWebAdmin.Admin.Menu.Group.Provider.self,
            context: SystemModuleWebAdmin.Admin.Menu.Context.self
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
            event: SystemModuleWebAdmin.Admin.Menu.Item.Provider.self,
            context: SystemModuleWebAdmin.Admin.Menu.Context.self
        ) { event, _ in
            guard event.menuKey == "account" else { return [] }
            return [
                .init(
                    menuKey: "account",
                    label: "Profile",
                    icon: "user",
                    link: AccountAdminRoutes.profile.description + "/"
                ),
                .init(
                    menuKey: "account",
                    label: "Settings",
                    icon: "settings",
                    link: AccountAdminRoutes.settings.description + "/"
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
