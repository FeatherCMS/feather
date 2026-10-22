import ContactModule
import SystemApplication
import SystemModule
public import FeatherModuleKit

extension ContactModule.Event {
    public enum Handlers {
        public static func register(
            in registry: inout EventRegistry
        ) {
            registry.register(
                event: Permission.Event.Seed.self
            ) { _ in
                ContactModule.Permissions.allPermissions()
                    .map {
                        .init(permission: $0)
                    }
            }
        }
    }
}

public enum EventHandlers {
    public static func register(
        in registry: inout EventRegistry
    ) {
        ContactModule.Event.Handlers.register(in: &registry)
    }
}
