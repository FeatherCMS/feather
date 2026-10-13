import FeatherAdmin
import Hummingbird

enum WebMenuItemRoutes {
    enum RemoveOrigin: String {
        case list
        case edit
        case view
    }

    static func list(_ menuID: RouterPath) -> RouterPath {
        WebMenuRoutes.items(menuID)
    }

    static func add(_ menuID: RouterPath) -> RouterPath {
        list(menuID).appendingPath(RouterPath("add"))
    }

    static func remove(_ menuID: RouterPath) -> RouterPath {
        list(menuID).appendingPath(RouterPath("remove"))
    }

    static func itemRemove(
        _ menuID: RouterPath,
        _ itemID: RouterPath,
        origin: RemoveOrigin
    ) -> String {
        NewAdminLocation.url(
            path: details(menuID, itemID)
                .appendingPath(RouterPath("remove")).description,
            queryItems: [("origin", origin.rawValue)]
        )
    }

    static func removeOrigin(_ value: String?) -> RemoveOrigin {
        RemoveOrigin(rawValue: value ?? "") ?? .list
    }

    static func removeCancel(
        _ menuID: RouterPath,
        _ itemID: RouterPath,
        origin: RemoveOrigin
    ) -> String {
        switch origin {
        case .list:
            list(menuID).description
        case .edit:
            edit(menuID, itemID).description
        case .view:
            details(menuID, itemID).description
        }
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
