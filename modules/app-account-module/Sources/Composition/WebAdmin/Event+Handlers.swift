import AccountModule
public import FeatherModuleKit
import FeatherWebAdmin
import Hummingbird
import SystemModule
import SystemWebAdmin

extension Event {
    public enum Handlers {
        public static func register(
            in events: inout EventRegistry,
            routes: Router.Routes = .standard
        ) {
            events.register(
                event: SystemWebAdmin.Admin.Menu.Group.Provider.self,
                context: SystemWebAdmin.Admin.Menu.Context.self
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
                event: SystemWebAdmin.Admin.Menu.Item.Provider.self,
                context: SystemWebAdmin.Admin.Menu.Context.self
            ) { event, _ in
                guard event.menuKey == "account" else { return [] }
                return [
                    .init(
                        menuKey: "account",
                        label: "Profile",
                        icon: "user",
                        link: routes.accountProfile.profile.path + "/"
                    ),
                    .init(
                        menuKey: "account",
                        label: "Settings",
                        icon: "settings",
                        link: routes.settings.settings.path + "/"
                    ),
                    .init(
                        menuKey: "account",
                        label: "Invitations",
                        icon: "mail",
                        link: routes.invitation.invitations.path + "/",
                        permission: "account:invitations:list"
                    ),
                ]
            }
        }
    }
}
