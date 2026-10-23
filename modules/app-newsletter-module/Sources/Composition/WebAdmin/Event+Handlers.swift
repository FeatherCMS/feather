public import FeatherModuleKit
import FeatherWebAdmin
import SystemModule
import SystemWebAdmin

extension Event {
    public enum Handlers {
        public static func registerMenu(in events: inout EventRegistry) {
            events.register(
                event: SystemWebAdmin.Admin.Menu.Group.Provider.self,
                context: SystemWebAdmin.Admin.Menu.Context.self
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
                event: SystemWebAdmin.Admin.Menu.Item.Provider.self,
                context: SystemWebAdmin.Admin.Menu.Context.self
            ) { event, _ in
                guard event.menuKey == "newsletter" else { return [] }
                return [
                    .init(
                        menuKey: "newsletter",
                        label: "Campaigns",
                        icon: "send",
                        link: "/admin/newsletter/campaigns/",
                        permission: "newsletter:campaigns:list"
                    ),
                    .init(
                        menuKey: "newsletter",
                        label: "Subscribers",
                        icon: "users",
                        link: "/admin/newsletter/subscribers/",
                        permission: "newsletter:subscribers:list"
                    ),
                ]
            }
        }

        public static func registerRichContentEditor(
            in registry: inout EventRegistry
        ) {
            registry.register(
                event: AdminRichContentEditorBlockProvider.self,
                context: SystemWebAdmin.Admin.Menu.Context.self
            ) { _, _ in
                AdminRichContentEditorBlockDefinition(
                    type: "newsletter",
                    title: "Newsletter campaign",
                    icon: "✉",
                    directive: "NewsletterCampaign",
                    pickerEndpoint: "/admin/newsletter/campaigns/?picker=1"
                )
            }
        }
    }
}
