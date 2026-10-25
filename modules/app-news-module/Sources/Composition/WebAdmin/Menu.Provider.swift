public import FeatherModuleKit
import FeatherWebAdmin
import SystemModule
import SystemWebAdmin

extension Menu {
    public enum Provider {
        public static func register(in events: inout EventRegistry) {
            events.register(
                event: SystemWebAdmin.Admin.Group.Provider.self,
                context: SystemWebAdmin.Admin.Context.self
            ) { _, _ in
                [
                    .init(
                        key: "news",
                        groupKey: "admin",
                        label: "News",
                        icon: "rss",
                        priority: 45
                    )
                ]
            }
        }
    }
}
