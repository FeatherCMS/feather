import ContactContracts
public import FeatherModuleKit
import SystemModule
import SystemApplication

public enum EventHandlers {

    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: Permission.Event.Seed.self
        ) { _ in
            ContactPermissions.allPermissions()
                .map {
                    .init(permission: $0)
                }
        }
    }
}
