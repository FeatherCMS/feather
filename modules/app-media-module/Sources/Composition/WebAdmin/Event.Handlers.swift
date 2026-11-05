public import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import SystemModule
import SystemWebAdmin

extension Event {
    public enum Handlers {
        public static func register(
            in events: inout EventRegistry,
            routes: Router.Routes = .standard
        ) {
            events.register(
                event: SystemWebAdmin.Admin.Menu.Group.Provider.self,
                context: SystemWebAdmin.Admin.Menu.Context.self
            ) { _, _ in
                [
                    .init(
                        key: "media",
                        groupKey: "admin",
                        label: "Media",
                        icon: "image",
                        priority: 20
                    )
                ]
            }
            events.register(
                event: SystemWebAdmin.Admin.Menu.Item.Provider.self,
                context: SystemWebAdmin.Admin.Menu.Context.self
            ) { event, _ in
                guard event.menuKey == "media" else { return [] }
                return [
                    .init(
                        menuKey: "media",
                        label: "Assets",
                        icon: "folder",
                        link: routes.assetList.path,
                        permission: "media:assets:list"
                    ),
                    .init(
                        menuKey: "media",
                        label: "Variants",
                        icon: "crop",
                        link: routes.variantList.path,
                        permission: "media:variants:list"
                    ),
                ]
            }
        }
    }
}
