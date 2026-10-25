public import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import SystemModule
import SystemWebAdmin

extension Event {
    public enum Handlers {
        public static func registerMenu(
            in events: inout EventRegistry,
            routes: Router.Routes
        ) {
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
                        link: routes.campaign.list.path,
                        permission: "newsletter:campaigns:list"
                    ),
                    .init(
                        menuKey: "newsletter",
                        label: "Subscribers",
                        icon: "users",
                        link: routes.subscriber.list.path,
                        permission: "newsletter:subscribers:list"
                    ),
                ]
            }
        }

        public static func registerRichContentEditor(
            in registry: inout EventRegistry,
            routes: Router.Routes
        ) {
            registry.register(
                event: AdminRichContentEditorBlockProvider.self,
                context: SystemWebAdmin.Admin.Menu.Context.self
            ) { _, _ in
                var components = URLComponents()
                components.path = routes.campaign.list.path
                components.queryItems = [
                    URLQueryItem(name: "picker", value: "1")
                ]
                return AdminRichContentEditorBlockDefinition(
                    type: "newsletter",
                    title: "Newsletter",
                    icon: "✉",
                    directive: "NewsletterCampaign",
                    pickerEndpoint: components.string ?? components.path
                )
            }
        }
    }
}
