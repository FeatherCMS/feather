import RedirectContracts
import FeatherContracts
import FeatherInfrastructure
import RedirectApplication
import SystemApplication

public enum EventHandlers {

    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: PermissionSeedProvider.self,
            context: EventContext.self
        ) { _, _ in
            RedirectPermissions.allPermissions()
                .map {
                    .init(permission: $0)
                }
        }
    }
}
