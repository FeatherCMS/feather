import FeatherAdmin
public import FeatherModuleKit
import Hummingbird
import SystemModule
import SystemWebAdmin

public enum RedirectAdminMenuEventHandlers {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: SystemWebAdmin.Admin.Menu.Group.Provider.self,
            context: SystemWebAdmin.Admin.Menu.Context.self
        ) { _, _ in
            [
                .init(
                    key: "redirect",
                    groupKey: "admin",
                    label: "Redirect",
                    icon: "gitBranch",
                    priority: 80
                )
            ]
        }
        events.register(
            event: SystemWebAdmin.Admin.Menu.Item.Provider.self,
            context: SystemWebAdmin.Admin.Menu.Context.self
        ) { event, _ in
            guard event.menuKey == "redirect" else { return [] }
            return [
                .init(
                    menuKey: "redirect",
                    label: "Rules",
                    icon: "cornerUpRight",
                    link: RedirectRuleRoutes.list.description + "/",
                    permission: "redirect:rules:list"
                )
            ]
        }
    }
}
