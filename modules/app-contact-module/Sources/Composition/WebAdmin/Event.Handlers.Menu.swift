public import FeatherModuleKit
import FeatherWebAdmin
import SystemModule
import SystemWebAdmin

extension Event {
    public enum Handlers {}
}

extension Event.Handlers {
    public static func registerMenu(in events: inout EventRegistry) {
        events.register(
            event: SystemWebAdmin.Admin.Menu.Group.Provider.self,
            context: SystemWebAdmin.Admin.Menu.Context.self
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
            event: SystemWebAdmin.Admin.Menu.Item.Provider.self,
            context: SystemWebAdmin.Admin.Menu.Context.self
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
