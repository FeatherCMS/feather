import FeatherAdmin
import FeatherContracts
import SystemApplication

public enum ContactAdminMenuEventHandlers {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: AdminMenuProvider.self,
            context: AdminEventContext.self
        ) { _, _ in
            [
                .init(
                    key: "contact",
                    groupKey: "admin",
                    label: "Contact",
                    icon: "messageSquare",
                    priority: 75
                )
            ]
        }
        events.register(
            event: AdminMenuItemProvider.self,
            context: AdminEventContext.self
        ) { event, _ in
            guard event.menuKey == "contact" else { return [] }
            return [
                .init(
                    menuKey: "contact",
                    label: "Forms",
                    icon: "clipboard",
                    link: "/admin/contact/forms/",
                    permission: "contact:forms:list"
                ),
                .init(
                    menuKey: "contact",
                    label: "Fields",
                    icon: "list",
                    link: "/admin/contact/fields/",
                    permission: "contact:form-fields:list"
                ),
                .init(
                    menuKey: "contact",
                    label: "Submissions",
                    icon: "inbox",
                    link: "/admin/contact/submissions/",
                    permission: "contact:form-submissions:list"
                ),
            ]
        }
    }
}
