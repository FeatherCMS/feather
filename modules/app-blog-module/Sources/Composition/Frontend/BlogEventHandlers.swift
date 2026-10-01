public import FeatherContracts
import SystemContracts
import WebContracts
import WebFrontend

public enum BlogEventHandlers {
    public static func register(in registry: inout EventRegistry) {
        registry.register(
            event: WebTemplateProviderEvent.self,
            context: WebFrontendEventContext.self
        ) { _, _ in
            BlogWebTemplateProvider()
        }

    }
}
