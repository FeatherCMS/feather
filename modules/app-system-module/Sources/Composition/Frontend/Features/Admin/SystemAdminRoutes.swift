import FeatherAdmin
import Hummingbird

enum SystemAdminRoutes {
    static let admin = RouterPath("admin")
    static let system = admin.appendingPath(RouterPath("system"))

    static let breadcrumb: [AdminBreadcrumb.Link] = [
        .init(label: "Admin", link: "/admin/"),
        .init(label: "System", link: "/admin/system/"),
    ]
}
