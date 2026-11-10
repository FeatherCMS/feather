public import FeatherModuleKit
public import NewsModule
import SystemApplication
import SystemModule
import WebDomain
public import WebModule

extension NewsModule.Event {
    public enum Handlers {
        public static let mainMenuItems: [MenuItem.Definition] = [
            .init(
                label: "News",
                url: "/news/",
                priority: 40
            ),
            .init(
                label: "Categories",
                url: "/news/categories/",
                priority: 45
            ),
        ]

        public static func register(
            in registry: inout EventRegistry
        ) {
            registry.register(
                event: Permission.Event.Seed.self
            ) { _ in
                NewsModule.Permissions.all()
                    .map {
                        .init(permission: $0)
                    }
            }

            registry.register(
                event: Variable.Event.Seed.self
            ) { _ in
                [
                    .init(
                        key: "news-settings-article-path-prefix",
                        value: "news",
                        name: "News article path prefix",
                        notes: "Public news article detail path prefix."
                    ),
                    .init(
                        key: "news-settings-category-path-prefix",
                        value: "news/categories",
                        name: "News category path prefix",
                        notes: "Public news category detail path prefix."
                    ),
                ]
            }

            registry.register(
                event: MenuItem.Provider.self,
                context: WebModule.Event.Context.self
            ) { event, _ in
                guard event.menuKey == "main" else { return [] }
                return mainMenuItems
            }

            registry.register(
                event: Page.Provider.self,
                context: WebModule.Event.Context.self
            ) { _, _ in
                [
                    .init(
                        title: "News",
                        excerpt: "Published news articles.",
                        content: "Published news articles.",
                        metadata: .init(
                            template: "news.articles",
                            slug: "news",
                            status: .published
                        )
                    ),
                    .init(
                        title: "News categories",
                        excerpt: "Browse news by category.",
                        content: "Browse news by category.",
                        metadata: .init(
                            template: "news.categories",
                            slug: "news/categories",
                            status: .published
                        )
                    ),
                ]
            }

        }
    }
}
