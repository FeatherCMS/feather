import FeatherContracts
import WebContracts

public enum NewsEventHandlers {
    public static func register(in registry: inout EventRegistry) {
        registry.register(
            event: WebTemplateProviderEvent.self,
            context: WebEventContext.self
        ) { _, _ in
            NewsWebTemplateProvider()
        }

        registry.register(
            event: WebMetadataReferenceTypeOptionProvider.self,
            context: WebEventContext.self
        ) { _, _ in
            [
                .init(value: "news.article", title: "News article"),
                .init(value: "news.category", title: "News category"),
            ]
        }

    }
}
