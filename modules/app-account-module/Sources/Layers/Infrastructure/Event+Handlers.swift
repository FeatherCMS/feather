public import AccountModule
import FeatherInfrastructure
public import FeatherModuleKit
import SystemApplication
import SystemModule
import UserApplication
import UserModule

extension AccountModule.Event {
    public enum Handlers {

        public static func register(
            in registry: inout EventRegistry
        ) {
            registry.register(
                event: Permission.Event.Seed.self
            ) { _ in
                AccountModule.Permissions.allPermissions()
                    .map {
                        .init(permission: $0)
                    }
            }

            registry.register(
                event: Identity.Event.DidInsert.self,
                context: DatabaseTransactionContext.self
            ) { event, context in
                _ = try await Settings.Repository.Database(context: context)
                    .getOrCreate(userId: event.identityID)
                _ = try await Profile.Repository
                    .Database(context: context)
                    .getOrCreate(userId: event.identityID)
            }
        }
    }
}
