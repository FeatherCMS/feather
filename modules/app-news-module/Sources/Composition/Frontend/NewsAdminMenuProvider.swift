import FeatherAdmin
public import FeatherContracts

public enum NewsAdminMenuProvider {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: AdminMenuProvider.self,
            context: AdminEventContext.self
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
