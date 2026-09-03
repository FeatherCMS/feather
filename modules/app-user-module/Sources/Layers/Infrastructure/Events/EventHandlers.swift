import FeatherContracts
import FeatherDomain
import FeatherInfrastructure
import SystemApplication
import UserApplication
import UserContracts
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
        ) { _, context in
            [
                .init(
                    id: context.idGenerator.generate(),
                    name: "Editor"
                )
            ]
        }

        registry.register(
            event: UserIdentitySeedProvider.self,
            context: UserEventContext.self
        ) { _, context in
            [
                .init(
                    id: context.idGenerator.generate(),
                    name: "Root User",
                    isRoot: true
                )
            ]
        }
    }
}
