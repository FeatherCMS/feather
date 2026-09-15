import FeatherContracts
import FeatherInfrastructure
import NewsApplication
import NewsContracts
import SystemApplication
import WebApplication
import WebContracts

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

    }
}
