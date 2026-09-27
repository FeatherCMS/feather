public import FeatherContracts
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

        registry.register(
            event: AccessControlProvider.self,
            context: AccessControlContext.self
        ) { event, _ in
            guard event.roleKey == "editor" else { return [] }
            return MediaPermissions.allPermissions().map { $0 }
        }
    }
}
