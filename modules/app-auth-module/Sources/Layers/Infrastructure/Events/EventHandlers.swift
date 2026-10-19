import AuthContracts
public import FeatherModuleKit
import SystemApplication
import SystemModule

public enum EventHandlers {
    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: Permission.Event.Seed.self
        ) { _ in
            AuthPermissions.allPermissions()
                .map {
                    .init(permission: $0)
                }
        }
    }
}
