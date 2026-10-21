public import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import SystemModule
import SystemWebAdmin

public enum AuthAdminMenuEventHandlers {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: SystemWebAdmin.Admin.Menu.Group.Provider.self,
            context: SystemWebAdmin.Admin.Menu.Context.self
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
            event: SystemWebAdmin.Admin.Menu.Item.Provider.self,
            context: SystemWebAdmin.Admin.Menu.Context.self
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
                    link: WebRoute.root
                        .appending(pathComponent: "admin")
                        .appending(pathComponent: "auth")
                        .appending(pathComponent: "credentials")
                        .path,
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
