public import FeatherModuleKit
import WebModule

public enum Event {
    public enum Handlers {
        public static func register(in registry: inout EventRegistry) {
            registry.register(
                event: WebModule.Template.Event.Provider.self,
                context: WebModule.Event.Context.self
            ) { _, _ in
                NewsWebTemplateProvider()
            }
        }
    }
}
