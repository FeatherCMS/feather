public import AnalyticsModule
public import FeatherModuleKit
import SystemApplication
import SystemModule

extension AnalyticsModule.Event {
    public enum Handlers {
        public static func register(
            in registry: inout EventRegistry
        ) {
            registry.register(
                event: Permission.Event.Seed.self
            ) { _ in
                AnalyticsModule.Permissions.allPermissions()
                    .map {
                        .init(permission: $0)
                    }
            }
        }
    }
}
