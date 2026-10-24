public import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import SystemModule
import SystemWebAdmin

extension Event {
    public enum Handlers {
        public static func registerMenu(
            in events: inout EventRegistry,
            routes: Router.Routes = .standard
        ) {
            events.register(
                event: SystemWebAdmin.Admin.Menu.Item.Provider.self,
                context: SystemWebAdmin.Admin.Menu.Context.self
            ) { event, _ in
                guard event.menuKey == "news" else { return [] }
                return [
                    .init(
                        menuKey: "news",
                        label: "Articles",
                        icon: "fileText",
                        link: routes.articles.path,
                        permission: "news:article:list"
                    ),
                    .init(
                        menuKey: "news",
                        label: "Categories",
                        icon: "tag",
                        link: routes.categories.path,
                        permission: "news:category:list"
                    ),
                ]
            }
        }
    }
}
