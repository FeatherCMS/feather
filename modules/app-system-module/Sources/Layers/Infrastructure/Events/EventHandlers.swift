public import FeatherContracts
import SystemApplication
import SystemContracts

public enum EventHandlers {

    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: PermissionSeedProvider.self,
            context: EventContext.self
        ) { _, _ in
            SystemPermissions.allPermissions()
                .map {
                    .init(permission: $0)
                }
        }

        registry.register(
            event: AccessControlProvider.self,
            context: AccessControlContext.self
        ) { event, _ in
            guard event.roleKey == "editor" else { return [] }
            return [SystemPermissions.Admin.access]
        }
    }
}
