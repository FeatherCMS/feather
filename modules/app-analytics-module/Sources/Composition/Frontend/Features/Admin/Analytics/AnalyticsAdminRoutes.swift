import FeatherAdmin
import Hummingbird

enum AnalyticsAdminRoutes {
    static let admin = RouterPath("admin")
    static let analytics = admin.appendingPath(RouterPath("analytics"))
    static let web = analytics.appendingPath(RouterPath("web"))
    static let api = analytics.appendingPath(RouterPath("api"))
    static let logs = analytics.appendingPath(RouterPath("logs"))
    static let notFound = analytics.appendingPath(RouterPath("not-found"))

    static func log(_ id: RouterPath) -> RouterPath {
        logs.appendingPath(id)
    }

    static let adminBreadcrumb: [NewAdminBreadcrumb.Link] = [
        .init(label: "Admin", link: "/admin/")
    ]

    static let breadcrumb: [NewAdminBreadcrumb.Link] = [
        adminBreadcrumb[0],
        .init(label: "Analytics", link: "/admin/analytics/"),
    ]
}
