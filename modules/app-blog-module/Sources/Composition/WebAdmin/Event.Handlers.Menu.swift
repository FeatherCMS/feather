public import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import SystemModule
import SystemWebAdmin

extension Event.Handlers {
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
                    key: "blog",
                    groupKey: "admin",
                    label: "Blog",
                    icon: "edit3",
                    priority: 40
                )
            ]
        }
        events.register(
            event: SystemWebAdmin.Admin.Menu.Item.Provider.self,
            context: SystemWebAdmin.Admin.Menu.Context.self
        ) { event, _ in
            guard event.menuKey == "blog" else { return [] }
            return [
                .init(
                    menuKey: "blog",
                    label: "Posts",
                    icon: "fileText",
                    link: routes.post.posts.path,
                    permission: "blog:posts:list"
                ),
                .init(
                    menuKey: "blog",
                    label: "Authors",
                    icon: "users",
                    link: routes.author.authors.path,
                    permission: "blog:authors:list"
                ),
                .init(
                    menuKey: "blog",
                    label: "Tags",
                    icon: "tag",
                    link: routes.tag.tags.path,
                    permission: "blog:tags:list"
                ),
                .init(
                    menuKey: "blog",
                    label: "Settings",
                    icon: "settings",
                    link: routes.settings.settings.path,
                    permission: "blog:settings:read"
                ),
            ]
        }
    }
}
