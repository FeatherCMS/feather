public import FeatherModuleKit
import FeatherWebAdmin
import SystemModule
import SystemWebAdmin

public enum NewsAdminMenuProvider {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: SystemWebAdmin.Admin.Menu.Group.Provider.self,
            context: SystemWebAdmin.Admin.Menu.Context.self
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
