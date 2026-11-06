import ContactModule
public import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import SystemModule
import SystemWebAdmin

extension Event {
    public enum Handlers {}
}

extension Event.Handlers {
    public static func registerMenu(
        in events: inout EventRegistry,
        routes: Contact.Router.Routes
    ) {
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
                    link: routes.forms.path,
                    permission: "contact:forms:list"
                ),
                .init(
                    menuKey: "contact",
                    label: "Fields",
                    icon: "list",
                    link: routes.fields.path,
                    permission: "contact:form-fields:list"
                ),
                .init(
                    menuKey: "contact",
                    label: "Submissions",
                    icon: "inbox",
                    link: routes.submissions.path,
                    permission: "contact:form-submissions:list"
                ),
            ]
        }
    }
}
