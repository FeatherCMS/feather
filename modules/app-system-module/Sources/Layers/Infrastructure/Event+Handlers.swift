public import SystemModule
public import FeatherModuleKit
import SystemApplication

extension SystemModule.Event {
    public enum Handlers {

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
                return [SystemModule.Admin.Permissions.access]
            }
        }
    }
}
