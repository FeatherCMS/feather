public import AuthModule
public import FeatherModuleKit
import SystemApplication
import SystemModule
import WebModule

extension AuthModule.Event {
    public enum Handlers {
        public static func register(
            in registry: inout EventRegistry
        ) {
            registry.register(
                event: Permission.Event.Seed.self
            ) { _ in
                AuthModule.Permissions.all()
                    .map {
                        .init(permission: $0)
                    }
            }

            registry.register(
                event: MenuItem.Provider.self,
                context: WebModule.Event.Context.self
            ) { event, _ in
                guard event.menuKey == "main" else { return [] }
                return [
                    .init(
                        label: "Sign In",
                        url: "/login/?redirect=/admin/",
                        priority: 100,
                        authentication: .anonymous
                    ),
                    .init(
                        label: "Sign Out",
                        url: "/logout/",
                        priority: 110,
                        authentication: .authenticated
                    ),
                ]
            }
        }
    }
}
