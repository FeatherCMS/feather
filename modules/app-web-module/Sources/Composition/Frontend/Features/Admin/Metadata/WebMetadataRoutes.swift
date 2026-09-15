import FeatherAdmin
import Hummingbird

enum WebMetadataRoutes {
    static let list = WebAdminRoutes.web.appendingPath(RouterPath("metadata"))

    static var breadcrumb: [NewAdminBreadcrumb.Link] {
        WebAdminRoutes.breadcrumb + [
            .init(label: "Metadata", link: list.description)
        ]
    }

    static func details(_ id: RouterPath) -> RouterPath {
        list.appendingPath(id)
    }

    static func edit(_ id: RouterPath) -> RouterPath {
        details(id).appendingPath(RouterPath("edit"))
    }
}
