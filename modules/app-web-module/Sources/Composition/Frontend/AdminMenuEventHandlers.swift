import FeatherAdmin
public import FeatherModuleKit
import SystemModule
import SystemModuleWebAdmin

public enum WebAdminMenuEventHandlers {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: SystemModuleWebAdmin.Events.Menu.Provider.self,
            context: SystemModuleWebAdmin.Events.Context.self
        ) { _, _ in
            [
                .init(
                    key: "web",
                    groupKey: "admin",
                    label: "Web",
                    icon: "layout",
                    priority: 30
                )
            ]
        }
        events.register(
            event: SystemModuleWebAdmin.Events.MenuItem.Provider.self,
            context: SystemModuleWebAdmin.Events.Context.self
        ) { event, _ in
            guard event.menuKey == "web" else { return [] }
            return [
                .init(
                    menuKey: "web",
                    label: "Pages",
                    icon: "fileText",
                    link: "/admin/web/pages/",
                    permission: "web:pages:list"
                ),
                .init(
                    menuKey: "web",
                    label: "Menus",
                    icon: "menu",
                    link: "/admin/web/menus/",
                    permission: "web:menus:list"
                ),
                .init(
                    menuKey: "web",
                    label: "Settings",
                    icon: "settings",
                    link: "/admin/web/settings/",
                    permission: "web:settings:read"
                ),
            ]
        }
    }
}
