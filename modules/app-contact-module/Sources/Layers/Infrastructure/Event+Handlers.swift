public import ContactModule
public import FeatherModuleKit
import SystemApplication
import SystemModule

extension ContactModule.Event {
    public enum Handlers {
        public static func register(
            in registry: inout EventRegistry
        ) {
            registry.register(
                event: Permission.Event.Seed.self
            ) { _ in
                ContactModule.Permissions.all()
                    .map {
                        .init(permission: $0)
                    }
            }
        }
    }
}
