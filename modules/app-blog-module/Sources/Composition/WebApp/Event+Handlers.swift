public import FeatherModuleKit
import SystemModule
import WebModule

public enum Event {
    public enum Handlers {
        public static func register(in registry: inout EventRegistry) {
            registry.register(
                event: WebTemplateProviderEvent.self,
                context: WebModule.Event.Context.self
            ) { _, _ in
                Templates.Provider()
            }
        }
    }
}
