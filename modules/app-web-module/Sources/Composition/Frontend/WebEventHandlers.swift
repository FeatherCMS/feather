import FeatherContracts
import Foundation
import WebContracts

public enum WebEventHandlers {
    public static func register(in registry: inout EventRegistry) {
        registry.register(
            event: WebTemplateProviderEvent.self,
            context: WebEventContext.self
        ) { _, _ in
            DefaultWebTemplateProvider()
        }

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

private struct DefaultWebTemplateProvider: WebTemplateProvider {
    let templates: [WebTemplateDefinition] = [
        .init(id: "default", title: "Default", path: "pages/default"),
        .init(id: "home", title: "Home", path: "pages/home"),
        .init(id: "not-found", title: "Not found", path: "pages/not-found"),
        .init(id: "debug", title: "Debug", path: "pages/debug"),
    ]

    let bundledTemplatePaths: [URL] = [
        Bundle.module.url(forResource: "Templates", withExtension: nil)!
    ]
}
