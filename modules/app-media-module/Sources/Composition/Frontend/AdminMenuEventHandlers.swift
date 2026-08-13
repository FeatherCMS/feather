import FeatherAdmin
import FeatherContracts
import SystemApplication

public enum MediaAdminMenuEventHandlers {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: AdminMenuProvider.self,
            context: AdminEventContext.self
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
            event: AdminMenuItemProvider.self,
            context: AdminEventContext.self
        ) { event, _ in
            guard event.menuKey == "media" else { return [] }
            return [
                .init(
                    menuKey: "media",
                    label: "Assets",
                    icon: "box",
                    link: "/admin/media/assets/",
                    permission: "media:assets:list"
                ),
                .init(
                    menuKey: "media",
                    label: "Processors",
                    icon: "playCircle",
                    link: "/admin/media/processors/",
                    permission: "media:processors:list"
                ),
            ]
        }
    }
}
