import FeatherAdmin
import Hummingbird

enum UserAdminRoutes {
    static let admin = RouterPath("admin")
    static let user = admin.appendingPath(RouterPath("user"))

    static let breadcrumb: [NewAdminBreadcrumb.Link] = [
        .init(label: "Admin", link: "/admin/"),
        .init(label: "User", link: "/admin/user/"),
    ]
}
