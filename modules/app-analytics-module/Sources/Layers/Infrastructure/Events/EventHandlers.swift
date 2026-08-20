import AnalyticsContracts
import AnalyticsApplication
import FeatherContracts
import FeatherInfrastructure
import SystemApplication

public enum EventHandlers {
    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: PermissionSeedProvider.self,
            context: EventContext.self
        ) { _, _ in
            AnalyticsPermissions.allPermissions()
                .map {
                    .init(permission: $0)
                }
        }
    }
}
