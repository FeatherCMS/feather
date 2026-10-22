import FeatherWebAdmin
import Hummingbird

enum MenuRoutes {
    static let list = AdminRoutes.web.appendingPath(RouterPath("menus"))
    static let add = list.appendingPath(RouterPath("add"))
    static let remove = list.appendingPath(RouterPath("remove"))

    static var breadcrumb: [AdminBreadcrumb.Link] {
        AdminRoutes.breadcrumb + [
            .init(label: "Menus", link: list.description)
        ]
    }

    static var listBreadcrumb: [AdminBreadcrumb.Link] {
        AdminRoutes.breadcrumb
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
