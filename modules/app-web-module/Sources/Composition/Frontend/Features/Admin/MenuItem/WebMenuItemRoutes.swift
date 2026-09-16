import FeatherAdmin
import Hummingbird

enum WebMenuItemRoutes {
    static func list(_ menuID: RouterPath) -> RouterPath {
        WebMenuRoutes.items(menuID)
    }

    static func add(_ menuID: RouterPath) -> RouterPath {
        list(menuID).appendingPath(RouterPath("add"))
    }

    static func remove(_ menuID: RouterPath) -> RouterPath {
        list(menuID).appendingPath(RouterPath("remove"))
    }

    static func details(_ menuID: RouterPath, _ id: RouterPath) -> RouterPath {
        list(menuID).appendingPath(id)
    }

    static func edit(_ menuID: RouterPath, _ id: RouterPath) -> RouterPath {
        details(menuID, id).appendingPath(RouterPath("edit"))
    }

    static func move(_ menuID: RouterPath, _ id: RouterPath) -> RouterPath {
        details(menuID, id).appendingPath(RouterPath("move"))
    }

    static func breadcrumb(_ menuID: RouterPath) -> [NewAdminBreadcrumb.Link] {
        menuBreadcrumb(menuID) + [
            .init(
                label: "Items",
                link: list(menuID).description
            )
        ]
    }

    static func menuBreadcrumb(
        _ menuID: RouterPath
    ) -> [NewAdminBreadcrumb.Link] {
        WebAdminRoutes.breadcrumb + [
            .init(
                label: "Menus",
                link: WebMenuRoutes.list.description
            ),
            .init(
                label: "Menu",
                link: WebMenuRoutes.details(menuID).description
            ),
        ]
    }
}
