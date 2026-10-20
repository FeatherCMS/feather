import FeatherAdmin
public import FeatherModuleKit
import Hummingbird
import SystemModule
import SystemModuleWebAdmin

public enum AuthAdminMenuEventHandlers {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: SystemModuleWebAdmin.Events.Menu.Provider.self,
            context: SystemModuleWebAdmin.Events.Context.self
        ) { _, _ in
            [
                .init(
                    key: "auth",
                    groupKey: "admin",
                    label: "Auth",
                    icon: "shield",
                    priority: 95
                )
            ]
        }
        events.register(
            event: SystemModuleWebAdmin.Events.MenuItem.Provider.self,
            context: SystemModuleWebAdmin.Events.Context.self
        ) { event, _ in
            guard event.menuKey == "auth" else { return [] }
            return [
                .init(
                    menuKey: "auth",
                    label: "Emails",
                    icon: "mail",
                    link: AuthEmailRoutes.list.description + "/",
                    permission: "auth:email:list"
                ),
                .init(
                    menuKey: "auth",
                    label: "Credentials",
                    icon: "key",
                    link: AuthCredentialRoutes.list.description + "/",
                    permission: "auth:credential:list"
                ),
                .init(
                    menuKey: "auth",
                    label: "Magic links",
                    icon: "link",
                    link: AuthMagicLinkRoutes.list.description + "/",
                    permission: "auth:magic-links:list"
                ),
                .init(
                    menuKey: "auth",
                    label: "Access Control",
                    icon: "unlock",
                    link: AuthAccessControlRoutes.accessControl.description
                        + "/",
                    permission: "auth:access-control:list"
                ),
            ]
        }
    }
}
