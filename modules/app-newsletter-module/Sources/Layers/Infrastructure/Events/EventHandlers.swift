import FeatherContracts
import FeatherInfrastructure
import NewsletterApplication
import NewsletterContracts
import SystemApplication

public enum EventHandlers {

    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: PermissionSeedProvider.self,
            context: EventContext.self
        ) { _, _ in
            Permissions.allPermissions()
                .map {
                    .init(permission: $0)
                }
        }
    }
}
