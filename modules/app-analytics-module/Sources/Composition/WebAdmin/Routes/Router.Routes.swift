import FeatherWebAdmin
import FeatherWebShared

extension Router {
    struct Routes {
        static let admin = WebRoute.root.appending(pathComponent: "admin")
        static let analytics = admin.appending(pathComponent: "analytics")
        static let web = analytics.appending(pathComponent: "web")
        static let api = analytics.appending(pathComponent: "api")
        static let logs = analytics.appending(pathComponent: "logs")
        static let log = logs.appending(parameter: "id")
        static let notFound = analytics.appending(pathComponent: "not-found")

        static let adminBreadcrumb: [AdminBreadcrumb.Link] = [
            .init(label: "Admin", link: admin.path)
        ]

        static let breadcrumb: [AdminBreadcrumb.Link] = [
            adminBreadcrumb[0],
            .init(label: "Analytics", link: analytics.path),
        ]
    }
}
