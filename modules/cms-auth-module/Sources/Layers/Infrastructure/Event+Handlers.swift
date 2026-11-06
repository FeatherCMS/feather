public import AuthModule
public import FeatherModuleKit
import SystemApplication
import SystemModule

extension AuthModule.Event {
    public enum Handlers {
        public static func register(
            in registry: inout EventRegistry
        ) {
            registry.register(
                event: Permission.Event.Seed.self
            ) { _ in
                AuthModule.Permissions.all()
                    .map {
                        .init(permission: $0)
                    }
            }
        }
    }
}
