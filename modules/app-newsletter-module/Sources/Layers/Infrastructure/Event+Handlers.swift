public import FeatherModuleKit
public import NewsletterModule
import SystemApplication
import SystemModule

extension NewsletterModule.Event {
    public enum Handlers {
        public static func register(
            in registry: inout EventRegistry
        ) {
            registry.register(
                event: Permission.Event.Seed.self
            ) { _ in
                NewsletterModule.Permissions.all()
                    .map {
                        .init(permission: $0)
                    }
            }
        }
    }
}
