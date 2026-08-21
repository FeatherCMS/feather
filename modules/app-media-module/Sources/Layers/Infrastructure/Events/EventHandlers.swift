import FeatherContracts
import FeatherInfrastructure
import MediaApplication
import MediaContracts
import SystemApplication

public enum EventHandlers {

    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: PermissionSeedProvider.self,
            context: EventContext.self
        ) { _, _ in
            MediaPermissions.allPermissions()
                .map {
                    .init(permission: $0)
                }
        }
    }
}
