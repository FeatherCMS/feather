import AccountApplication
import AccountContracts
import AccountDomain
import FeatherContracts
import FeatherInfrastructure
import SystemApplication
import SystemContracts
import UserApplication
import UserContracts

public enum EventHandlers {

    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: PermissionSeedProvider.self,
            context: EventContext.self
        ) { _, _ in
            AccountPermissions.allPermissions()
                .union(SettingsPermissions.allPermissions())
                .map {
                    .init(permission: $0)
                }
        }

        registry.register(
            event: UserIdentityDidInsert.self,
            context: DatabaseTransactionContext.self
        ) { event, context in
            try await SettingsDatabaseRepository(context: context)
                .create(userId: event.identityID)
        }
    }
}
