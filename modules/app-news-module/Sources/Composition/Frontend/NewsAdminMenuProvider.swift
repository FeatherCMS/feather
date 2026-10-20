import FeatherAdmin
public import FeatherModuleKit

public enum NewsAdminMenuProvider {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: WebAdmin.Events.Menu.Provider.self,
            context: WebAdmin.Events.Context.self
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
