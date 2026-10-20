import FeatherAdmin
public import FeatherModuleKit
import Hummingbird
import SystemModule
import SystemModuleWebAdmin

public enum RedirectAdminMenuEventHandlers {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: SystemModuleWebAdmin.Events.Menu.Provider.self,
            context: SystemModuleWebAdmin.Events.Context.self
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
            event: SystemModuleWebAdmin.Events.MenuItem.Provider.self,
            context: SystemModuleWebAdmin.Events.Context.self
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
