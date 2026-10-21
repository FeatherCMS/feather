import FeatherModuleKit
import RedirectModule
import SystemApplication
import SystemModule

extension RedirectModule.Event {
    public enum Handlers {
        public static func register(
            in registry: inout EventRegistry
        ) {
            registry.register(event: Permission.Event.Seed.self) { _ in
                RedirectModule.Permissions.allPermissions().map {
                    .init(permission: $0)
                }
            }
        }
    }
}
