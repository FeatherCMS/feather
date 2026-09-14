import FeatherAdmin
import Hummingbird

enum WebMenuRoutes {
    static let list = WebAdminRoutes.web.appendingPath(RouterPath("menus"))
    static let add = list.appendingPath(RouterPath("add"))
    static let remove = list.appendingPath(RouterPath("remove"))

    static var breadcrumb: [NewAdminBreadcrumb.Link] {
        WebAdminRoutes.breadcrumb + [
            .init(label: "Menus", link: list.description)
        ]
    }

    static var listBreadcrumb: [NewAdminBreadcrumb.Link] {
        WebAdminRoutes.breadcrumb
    }

    static func details(_ id: RouterPath) -> RouterPath {
        list.appendingPath(id)
    }

    static func edit(_ id: RouterPath) -> RouterPath {
        details(id).appendingPath(RouterPath("edit"))
    }

    static func items(_ id: RouterPath) -> RouterPath {
        details(id).appendingPath(RouterPath("items"))
    }
}
