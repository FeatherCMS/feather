public import AuthModule
public import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import SystemModule
import SystemWebAdmin

extension AuthModule.Event.Handlers {
    public static func registerMenu(in events: inout EventRegistry) {
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
            let authRoot = WebRoute.root
                .appending(pathComponent: "admin")
                .appending(pathComponent: "auth")
            let magicLinkListRoute =
                authRoot
                .appending(pathComponent: "magic-links")
            let accessControlRoute =
                authRoot
                .appending(pathComponent: "access-control")
            return [
                .init(
                    menuKey: "auth",
                    label: "Emails",
                    icon: "mail",
                    link: WebRoute.root
                        .appending(pathComponent: "admin")
                        .appending(pathComponent: "auth")
                        .appending(pathComponent: "emails")
                        .path,
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
                    link: magicLinkListRoute.path + "/",
                    permission: "auth:magic-links:list"
                ),
                .init(
                    menuKey: "auth",
                    label: "Access Control",
                    icon: "unlock",
                    link: accessControlRoute.path + "/",
                    permission: "auth:access-control:list"
                ),
            ]
        }
    }
}
