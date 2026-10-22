public import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import SystemModule
import SystemWebAdmin
public import UserModule

extension UserModule.Event {
    public enum Handlers {
        public static func register(
            in events: inout EventRegistry,
            routes: Router.Routes = .standard
        ) {
            let identityRoutes = Identity.Router.Routes(
                root: routes.user,
                breadcrumb: routes.breadcrumb
            )
            let roleRoutes = Role.Router.Routes(
                root: routes.user,
                breadcrumb: routes.breadcrumb
            )
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
                        link: identityRoutes.list.path,
                        permission: "user:identities:list"
                    ),
                    .init(
                        menuKey: "user",
                        label: "Roles",
                        icon: "shield",
                        link: roleRoutes.list.path,
                        permission: "user:roles:list"
                    ),
                ]
            }
        }
    }
}
