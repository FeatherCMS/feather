public import FeatherContracts
import Foundation
import WebContracts

public enum WebEventHandlers {
    public static func register(in registry: inout EventRegistry) {
        registry.register(
            event: WebTemplateProviderEvent.self,
            context: WebFrontendEventContext.self
        ) { _, _ in
            DefaultWebTemplateProvider()
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
