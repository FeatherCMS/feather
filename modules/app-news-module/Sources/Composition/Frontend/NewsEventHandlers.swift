import FeatherContracts
import WebContracts

public enum NewsEventHandlers {
    public static func register(in registry: inout EventRegistry) {
        registry.register(
            event: WebMetadataReferenceTypeOptionProvider.self,
            context: WebEventContext.self
        ) { _, _ in
            [
                .init(value: "news.article", title: "News article"),
                .init(value: "news.category", title: "News category"),
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
