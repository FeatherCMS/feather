import FeatherAdmin
import Hummingbird

enum SystemPermissionRoutes {
    private static let root = SystemAdminRoutes.system
        .appendingPath(RouterPath("permissions"))
    static let list = root
    static let add = root.appendingPath(RouterPath("add"))
    static let remove = root.appendingPath(RouterPath("remove"))

    static var listBreadcrumb: [NewAdminBreadcrumb.Link] {
        SystemAdminRoutes.breadcrumb
    }

    static var breadcrumb: [NewAdminBreadcrumb.Link] {
        SystemAdminRoutes.breadcrumb + [
            .init(label: "Permissions", link: list.description)
        ]
    }
    static func details(_ id: RouterPath) -> RouterPath {
        list.appendingPath(id)
    }
    static func edit(_ id: RouterPath) -> RouterPath {
        details(id).appendingPath(RouterPath("edit"))
    }
}
