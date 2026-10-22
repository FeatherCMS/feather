public import FeatherModuleKit
import WebModule

public enum NewsEventHandlers {
    public static func register(in registry: inout EventRegistry) {
        registry.register(
            event: TemplateProviderEvent.self,
            context: WebModule.Event.Context.self
        ) { _, _ in
            NewsWebTemplateProvider()
        }

    }
}
