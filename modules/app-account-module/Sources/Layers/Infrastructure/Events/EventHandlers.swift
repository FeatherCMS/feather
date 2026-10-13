import AccountContracts
public import FeatherContracts
import FeatherInfrastructure
import SystemApplication
import UserApplication

public enum EventHandlers {

    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: PermissionSeedProvider.self,
            context: EventContext.self
        ) { _, _ in
            AccountPermissions.allPermissions()
                .map {
                    .init(permission: $0)
                }
        }

        registry.register(
            event: UserIdentityDidInsert.self,
            context: DatabaseTransactionContext.self
        ) { event, context in
            _ = try await SettingsDatabaseRepository(context: context)
                .getOrCreate(userId: event.identityID)
            _ = try await AccountProfileDatabaseRepository(context: context)
                .getOrCreate(userId: event.identityID)
        }
    }
}
