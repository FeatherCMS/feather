import FeatherAdmin
import Hummingbird

enum UserRoleRoutes {
    private static let user = RouterPath("admin")
        .appendingPath(RouterPath("user"))
    static let list = user.appendingPath(RouterPath("roles"))
    static let add = list.appendingPath(RouterPath("add"))
    static let remove = list.appendingPath(RouterPath("remove"))

    static var listBreadcrumb: [NewAdminBreadcrumb.Link] {
        userBreadcrumb
    }

    static var breadcrumb: [NewAdminBreadcrumb.Link] {
        userBreadcrumb + [.init(label: "Roles", link: list.description)]
    }

    static var userBreadcrumb: [NewAdminBreadcrumb.Link] {
        [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "User", link: "/admin/user/"),
        ]
    }

    static func details(_ id: RouterPath) -> RouterPath {
        list.appendingPath(id)
    }

    static func edit(_ id: RouterPath) -> RouterPath {
        details(id).appendingPath(RouterPath("edit"))
    }

    static func remove(_ id: RouterPath) -> RouterPath {
        details(id).appendingPath(RouterPath("remove"))
    }
}
