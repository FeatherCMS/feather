public import FeatherModuleKit
import Foundation
import WebModule

public enum EventHandlers {
    public static func register(in registry: inout EventRegistry) {
        registry.register(
            event: TemplateProviderEvent.self,
            context: WebModule.Event.Context.self
        ) { _, _ in
            DefaultWebTemplateProvider()
        }

    }
}

private struct DefaultWebTemplateProvider: TemplateProvider {
    let templates: [TemplateDefinition] = [
        .init(id: "default", title: "Default", path: "pages/default"),
        .init(id: "home", title: "Home", path: "pages/home"),
        .init(id: "not-found", title: "Not found", path: "pages/not-found"),
        .init(id: "debug", title: "Debug", path: "pages/debug"),
    ]

    let bundledTemplatePaths: [URL] = [
        Bundle.module.url(forResource: "Templates", withExtension: nil)!
    ]
}
