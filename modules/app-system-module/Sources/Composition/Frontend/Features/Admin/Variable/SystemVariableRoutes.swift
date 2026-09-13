import FeatherAdmin
import Hummingbird

enum SystemVariableRoutes {
    static let list = SystemAdminRoutes.system.appendingPath(RouterPath("variables"))
    static let add = list.appendingPath(RouterPath("add"))
    static let remove = list.appendingPath(RouterPath("remove"))

    static var listBreadcrumb: [NewAdminBreadcrumb.Link] {
        SystemAdminRoutes.breadcrumb
    }

    static var breadcrumb: [NewAdminBreadcrumb.Link] {
        SystemAdminRoutes.breadcrumb + [
            .init(label: "Variables", link: list.description)
        ]
    }

    static func details(_ id: RouterPath) -> RouterPath {
        list.appendingPath(id)
    }

    static func edit(_ id: RouterPath) -> RouterPath {
        details(id).appendingPath(RouterPath("edit"))
    }

}
