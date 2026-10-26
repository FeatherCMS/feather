public import FeatherModuleKit
public import MediaModule
import SystemApplication
import SystemModule

extension MediaModule.Event {
    public enum Handlers {}
}

extension MediaModule.Event.Handlers {
    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: Permission.Event.Seed.self
        ) { _ in
            MediaModule.Permissions.all()
                .map {
                    .init(permission: $0)
                }
        }

        registry.register(
            event: AccessControlProvider.self,
            context: AccessControlContext.self
        ) { event, _ in
            guard event.roleKey == "editor" else { return [] }
            return MediaModule.Permissions.all().map { $0 }
        }
    }
}
