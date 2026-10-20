import FeatherAdmin
public import FeatherModuleKit
import Hummingbird
import SystemModule
import SystemWebAdmin

public enum UserAdminMenuEventHandlers {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: SystemWebAdmin.Admin.Menu.Group.Provider.self,
            context: SystemWebAdmin.Admin.Menu.Context.self
        ) { _, _ in
            [
                .init(
                    key: "user",
                    groupKey: "admin",
                    label: "User",
                    icon: "user",
                    priority: 100
                )
            ]
        }
        events.register(
            event: SystemWebAdmin.Admin.Menu.Item.Provider.self,
            context: SystemWebAdmin.Admin.Menu.Context.self
        ) { event, _ in
            guard event.menuKey == "user" else { return [] }
            return [
                .init(
                    menuKey: "user",
                    label: "Identities",
                    icon: "users",
                    link: UserIdentityRoutes.list.description + "/",
                    permission: "user:identities:list"
                ),
                .init(
                    menuKey: "user",
                    label: "Roles",
                    icon: "shield",
                    link: UserRoleRoutes.list.description + "/",
                    permission: "user:roles:list"
                ),
            ]
        }
    }
}
