public import FeatherModuleKit
public import RedirectModule
import SystemApplication
import SystemModule

extension RedirectModule.Event {
    public enum Handlers {
        public static func register(
            in registry: inout EventRegistry
        ) {
            registry.register(
                event: SystemModule.Permission.Event.Seed.self
            ) { _ in
                RedirectModule.Permissions.all()
                    .map {
                        .init(permission: $0)
                    }
            }
        }
    }
}
