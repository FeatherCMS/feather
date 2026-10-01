public import FeatherContracts
import NewsContracts
import SystemApplication

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

    }
}
