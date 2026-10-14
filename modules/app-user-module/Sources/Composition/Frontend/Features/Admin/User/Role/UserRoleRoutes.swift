import FeatherAdmin
import Hummingbird

enum UserRoleRoutes {
    static let list = UserAdminRoutes.user.appendingPath(
        RouterPath("roles")
    )
    static let add = list.appendingPath(RouterPath("add"))
    static let remove = list.appendingPath(RouterPath("remove"))

    static var listBreadcrumb: [AdminBreadcrumb.Link] {
        UserAdminRoutes.breadcrumb
    }

    static var breadcrumb: [AdminBreadcrumb.Link] {
        UserAdminRoutes.breadcrumb + [
            .init(label: "Roles", link: list.description)
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
