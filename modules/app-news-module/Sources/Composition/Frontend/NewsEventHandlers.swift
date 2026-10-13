public import FeatherContracts
import WebContracts
import WebFrontend

public enum NewsEventHandlers {
    public static func register(in registry: inout EventRegistry) {
        registry.register(
            event: WebTemplateProviderEvent.self,
            context: WebFrontendEventContext.self
        ) { _, _ in
            NewsWebTemplateProvider()
        }

    }
}
