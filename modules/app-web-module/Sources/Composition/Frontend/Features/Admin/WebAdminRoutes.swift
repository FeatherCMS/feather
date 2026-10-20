import FeatherWebAdmin
import Hummingbird

enum WebAdminRoutes {
    static let admin = RouterPath("admin")
    static let web = admin.appendingPath(RouterPath("web"))

    static let breadcrumb: [AdminBreadcrumb.Link] = [
        .init(label: "Admin", link: "/admin/"),
        .init(label: "Web", link: "/admin/web/"),
    ]
}
