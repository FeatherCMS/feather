import FeatherAdmin
import Hummingbird

enum AuthAdminRoutes {
    static let admin = RouterPath("admin")
    static let auth = admin.appendingPath(RouterPath("auth"))

    static let breadcrumb: [NewAdminBreadcrumb.Link] = [
        .init(label: "Admin", link: "/admin/"),
        .init(label: "Auth", link: "/admin/auth/"),
    ]
}
