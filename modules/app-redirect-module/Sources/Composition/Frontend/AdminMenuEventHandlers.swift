import FeatherAdmin
import FeatherContracts
import SystemApplication

public enum RedirectAdminMenuEventHandlers {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: AdminMenuProvider.self,
            context: AdminEventContext.self
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
            event: AdminMenuItemProvider.self,
            context: AdminEventContext.self
        ) { event, _ in
            guard event.menuKey == "redirect" else { return [] }
            return [
                .init(
                    menuKey: "redirect",
                    label: "Rules",
                    icon: "cornerUpRight",
                    link: "/admin/redirect/rules/",
                    permission: "redirect:rules:list"
                )
            ]
        }
    }
}
