public import FeatherModuleKit
import RedirectContracts
import SystemModule
import SystemApplication

public enum EventHandlers {

    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: Permission.Event.Seed.self
        ) { _ in
            RedirectPermissions.allPermissions()
                .map {
                    .init(permission: $0)
                }
        }
    }
}
