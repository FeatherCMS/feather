import FeatherDomain
public import FeatherModuleKit
import SystemApplication
import SystemModule
import UserApplication
public import UserModule

extension UserModule.Event {
    public enum Handlers {
        public static func register(
            in registry: inout EventRegistry
        ) {
            registry.register(
                event: Permission.Event.Seed.self
            ) { _ in
                UserModule.Permissions.allPermissions()
                    .map {
                        .init(permission: $0)
                    }
            }

            registry.register(
                event: Role.Event.Seed.Provider.self,
                context: Context.self
            ) { _, _ in
                [
                    .init(
                        key: "editor",
                        name: "Editor"
                    )
                ]
            }

            registry.register(
                event: Identity.Event.Seed.Provider.self,
                context: Context.self
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
}
