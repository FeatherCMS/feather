import AnalyticsContracts
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
            AnalyticsPermissions.allPermissions()
                .map {
                    .init(permission: $0)
                }
        }
    }
}
