import FeatherContracts
import FeatherInfrastructure
import SystemApplication
import UserApplication
import UserDomain

public enum EventHandlers {

    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: PermissionSeedProvider.self,
            context: EventContext.self
        ) { _, _ in
            UserPermissions.allPermissions()
                .map {
                    .init(permission: $0)
                }
        }

        registry.register(
            event: UserRoleSeedProvider.self,
            context: UserEventContext.self
        ) { _, _ in
            [
                .init(
                    id: "editor",
                    name: "Editor"
                ),
                .init(
                    id: "root",
                    name: "Root"
                )
            ]
        }

        registry.register(
            event: UserIdentitySeedProvider.self,
            context: UserEventContext.self
        ) { _, _ in
            [
                .init(id: "root", isRoot: true)
            ]
        }
    }
}
