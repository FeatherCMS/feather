import FeatherAdmin
public import FeatherModuleKit
import SystemModule
import SystemModuleWebAdmin

public enum NewsAdminMenuEventHandlers {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: SystemModuleWebAdmin.Admin.Menu.Item.Provider.self,
            context: SystemModuleWebAdmin.Admin.Menu.Context.self
        ) { event, _ in
            guard event.menuKey == "news" else { return [] }
            return [
                .init(
                    menuKey: "news",
                    label: "Articles",
                    icon: "fileText",
                    link: "/admin/news/articles/",
                    permission: "news:article:list"
                ),
                .init(
                    menuKey: "news",
                    label: "Categories",
                    icon: "tag",
                    link: "/admin/news/categories/",
                    permission: "news:category:list"
                ),
            ]
        }
    }
}
