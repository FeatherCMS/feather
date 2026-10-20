import FeatherAdmin
public import FeatherModuleKit
import SystemModule
import SystemModuleWebAdmin

public enum MediaAdminMenuEventHandlers {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: SystemModuleWebAdmin.Events.Menu.Provider.self,
            context: SystemModuleWebAdmin.Events.Context.self
        ) { _, _ in
            [
                .init(
                    key: "media",
                    groupKey: "admin",
                    label: "Media",
                    icon: "image",
                    priority: 20
                )
            ]
        }
        events.register(
            event: SystemModuleWebAdmin.Events.MenuItem.Provider.self,
            context: SystemModuleWebAdmin.Events.Context.self
        ) { event, _ in
            guard event.menuKey == "media" else { return [] }
            return [
                .init(
                    menuKey: "media",
                    label: "Assets",
                    icon: "folder",
                    link: "/admin/media/assets/",
                    permission: "media:assets:list"
                ),
                .init(
                    menuKey: "media",
                    label: "Variants",
                    icon: "crop",
                    link: "/admin/media/variants/",
                    permission: "media:variants:list"
                ),
            ]
        }
    }
}
