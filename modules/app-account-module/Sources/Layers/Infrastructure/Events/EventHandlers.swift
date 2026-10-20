import AccountContracts
public import FeatherModuleKit
import FeatherInfrastructure
import SystemApplication
import SystemModule
import UserApplication

public enum EventHandlers {

    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: Permission.Event.Seed.self
        ) { _ in
            AccountPermissions.allPermissions()
                .map {
                    .init(permission: $0)
                }
        }

        registry.register(
            event: Identity.Event.DidInsert.self,
            context: DatabaseTransactionContext.self
        ) { event, context in
            _ = try await SettingsDatabaseRepository(context: context)
                .getOrCreate(userId: event.identityID)
            _ = try await AccountProfileDatabaseRepository(context: context)
                .getOrCreate(userId: event.identityID)
        }
    }
}
