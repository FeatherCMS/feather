import AuthApplication
import FeatherContracts
import FeatherInfrastructure
import SystemApplication
import WebApplication
import WebDomain

public enum EventHandlers {
    public static func register(
        in registry: inout EventRegistry
    ) {
        registry.register(
            event: PermissionSeedProvider.self,
            context: EventContext.self
        ) { _, _ in
            AuthPermissions.allPermissions()
                .map {
                    .init(permission: $0)
                }
        }

        registry.register(
            event: WebMenuItemProvider.self,
            context: WebEventContext.self
        ) { event, _ in
            guard event.menuKey == "main" else { return [] }
            return [
                .init(
                    label: "Admin",
                    url: "/admin/",
                    priority: 90,
                    permission: "system.admin.access",
                    authentication: .authenticated
                ),
                .init(
                    label: "Sign in",
                    url: "/login/",
                    priority: 100,
                    authentication: .anonymous
                ),
                .init(
                    label: "Sign out",
                    url: "/logout/",
                    priority: 110,
                    authentication: .authenticated
                ),
            ]
        }
    }
}
