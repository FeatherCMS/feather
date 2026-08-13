import FeatherAdmin
import FeatherContracts
import SystemApplication

public enum BlogAdminMenuEventHandlers {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: AdminMenuProvider.self,
            context: AdminEventContext.self
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
            event: AdminMenuItemProvider.self,
            context: AdminEventContext.self
        ) { event, _ in
            guard event.menuKey == "blog" else { return [] }
            return [
                .init(
                    menuKey: "blog",
                    label: "Posts",
                    icon: "fileText",
                    link: "/admin/blog/posts/",
                    permission: "blog:posts:list"
                ),
                .init(
                    menuKey: "blog",
                    label: "Authors",
                    icon: "users",
                    link: "/admin/blog/authors/",
                    permission: "blog:authors:list"
                ),
                .init(
                    menuKey: "blog",
                    label: "Tags",
                    icon: "tag",
                    link: "/admin/blog/tags/",
                    permission: "blog:tags:list"
                ),
                .init(
                    menuKey: "blog",
                    label: "Settings",
                    icon: "settings",
                    link: "/admin/blog/settings/",
                    permission: "blog:settings:read"
                ),
            ]
        }
    }
}
