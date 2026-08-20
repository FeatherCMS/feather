import FeatherContracts
import WebContracts

public enum WebEventHandlers {
    public static func register(in registry: inout EventRegistry) {
        registry.register(
            event: WebMenuProvider.self,
            context: WebEventContext.self
        ) { _, _ in
            [.init(key: "main", name: "Main Menu", notes: "Main navigation.")]
        }

        registry.register(
            event: WebMetadataReferenceTypeOptionProvider.self,
            context: WebEventContext.self
        ) { _, _ in
            [.init(value: "web.page", title: "Web page")]
        }

        registry.register(
            event: WebPageTemplateOptionProvider.self,
            context: WebEventContext.self
        ) { _, _ in
            [.init(value: "default", title: "Default")]
        }

        registry.register(
            event: WebPageProvider.self,
            context: WebEventContext.self
        ) { _, _ in
            [
                .init(
                    title: "Welcome Page",
                    excerpt: "This is the welcome page",
                    content:
                        "# Welcome\n\nThis page is provided by the web module.",
                    metadata: .init(
                        template: "default",
                        slug: "web.welcome",
                        status: .published
                    )
                )
            ]
        }
    }
}
