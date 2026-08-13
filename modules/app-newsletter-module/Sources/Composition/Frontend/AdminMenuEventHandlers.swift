import FeatherAdmin
import FeatherContracts
import SystemApplication

public enum NewsletterAdminMenuEventHandlers {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: AdminMenuProvider.self,
            context: AdminEventContext.self
        ) { _, _ in
            [
                .init(
                    key: "newsletter",
                    groupKey: "admin",
                    label: "Newsletter",
                    icon: "mail",
                    priority: 70
                )
            ]
        }
        events.register(
            event: AdminMenuItemProvider.self,
            context: AdminEventContext.self
        ) { event, _ in
            guard event.menuKey == "newsletter" else { return [] }
            return [
                .init(
                    menuKey: "newsletter",
                    label: "Campaigns",
                    icon: "send",
                    link: "/admin/newsletters/",
                    permission: "newsletter:campaigns:list"
                ),
                .init(
                    menuKey: "newsletter",
                    label: "Subscribers",
                    icon: "users",
                    link: "/admin/newsletters/subscribers/",
                    permission: "newsletter:subscribers:list"
                ),
            ]
        }
    }
}
