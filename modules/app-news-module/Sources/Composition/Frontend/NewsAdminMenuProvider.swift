import FeatherAdmin
public import FeatherModuleKit
import SystemModule
import SystemModuleWebAdmin

public enum NewsAdminMenuProvider {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: SystemModuleWebAdmin.Admin.Menu.Group.Provider.self,
            context: SystemModuleWebAdmin.Admin.Menu.Context.self
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
