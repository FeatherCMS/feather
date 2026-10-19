public import FeatherModuleKit
import NewsletterContracts
import SystemModule
import SystemApplication

public enum EventHandlers {

    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: Permission.Event.Seed.self
        ) { _ in
            NewsletterContracts.Permissions.allPermissions()
                .map {
                    .init(permission: $0)
                }
        }
    }
}
