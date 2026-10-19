import SystemModule
public import FeatherModuleKit
import SystemApplication

public enum EventHandlers {

    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: SystemModule.Permission.Event.Seed.self
        ) { _ in
            SystemModule.Permissions.all()
                .map {
                    .init(permission: $0)
                }
        }

        registry.register(
            event: AccessControlProvider.self,
            context: AccessControlContext.self
        ) { event, _ in
            guard event.roleKey == "editor" else { return [] }
            return [Admin.Permissions.access]
        }
    }
}
