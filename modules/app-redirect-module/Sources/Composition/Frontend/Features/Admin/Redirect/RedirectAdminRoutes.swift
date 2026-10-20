import FeatherWebAdmin
import Hummingbird

enum RedirectAdminRoutes {
    static let admin = RouterPath("admin")
    static let redirect = admin.appendingPath(RouterPath("redirect"))

    static let breadcrumb: [AdminBreadcrumb.Link] = [
        .init(label: "Admin", link: "/admin/"),
        .init(label: "Redirect", link: "/admin/redirect/"),
    ]
}
