import FeatherAdmin
import Hummingbird

enum UserRoleRoutes {
    static let list = UserAdminRoutes.user.appendingPath(
        RouterPath("roles")
    )
    static let add = list.appendingPath(RouterPath("add"))
    static let remove = list.appendingPath(RouterPath("remove"))
    static let detailsPattern = details(RouterPath("{id}"))
    static let editPattern = edit(RouterPath("{id}"))
    static let removePattern = remove(RouterPath("{id}"))

    static var listBreadcrumb: [NewAdminBreadcrumb.Link] {
        UserAdminRoutes.breadcrumb
    }

    static var breadcrumb: [NewAdminBreadcrumb.Link] {
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
