public import FeatherModuleKit
import FeatherWebAdmin
import SystemModule
import SystemWebAdmin
public import WebModule

extension WebModule.Event.Handlers {
    public static func registerMenu(in events: inout EventRegistry) {
        events.register(
            event: SystemWebAdmin.Admin.Menu.Group.Provider.self,
            context: SystemWebAdmin.Admin.Menu.Context.self
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
            event: SystemWebAdmin.Admin.Menu.Item.Provider.self,
            context: SystemWebAdmin.Admin.Menu.Context.self
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
