import NewsContracts
import FeatherContracts
import FeatherInfrastructure
import NewsApplication
import SystemApplication
import WebApplication

public enum EventHandlers {

    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: PermissionSeedProvider.self,
            context: EventContext.self
        ) { _, _ in
            NewsPermissions.allPermissions()
                .map {
                    .init(permission: $0)
                }
        }

        registry.register(
            event: VariableSeedProvider.self,
            context: EventContext.self
        ) { _, _ in
            [
                .init(
                    id: "news-settings-article-path-prefix",
                    value: "news",
                    name: "news.article.path_prefix",
                    notes: "Public news article detail path prefix."
                ),
                .init(
                    id: "news-settings-category-path-prefix",
                    value: "news/categories",
                    name: "news.category.path_prefix",
                    notes: "Public news category detail path prefix."
                ),
            ]
        }

        registry.register(
            event: WebMetadataReferenceTypeOptionProvider.self,
            context: WebEventContext.self
        ) { _, _ in
            [
                .init(
                    value: "news.article",
                    title: "News article"
                ),
                .init(
                    value: "news.category",
                    title: "News category"
                ),
            ]
        }

        registry.register(
            event: WebPageTemplateOptionProvider.self,
            context: WebEventContext.self
        ) { _, _ in
            [
                .init(value: "news.articles", title: "News articles"),
                .init(value: "news.categories", title: "News categories"),
            ]
        }
    }
}
