public import FeatherModuleKit
import MediaContracts
import SystemModule
import SystemApplication

public enum EventHandlers {

    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: Permission.Event.Seed.self
        ) { _ in
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
