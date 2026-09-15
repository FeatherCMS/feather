import FeatherAdmin
import Hummingbird

enum WebPageRoutes {
    static let list = WebAdminRoutes.web.appendingPath(RouterPath("pages"))
    static let add = list.appendingPath(RouterPath("add"))
    static let remove = list.appendingPath(RouterPath("remove"))

    static var breadcrumb: [NewAdminBreadcrumb.Link] {
        WebAdminRoutes.breadcrumb + [
            .init(label: "Pages", link: list.description)
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

    static func status(_ id: RouterPath) -> RouterPath {
        details(id).appendingPath(RouterPath("status"))
    }
}
