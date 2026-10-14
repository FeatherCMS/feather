import FeatherAdmin
import Hummingbird

enum WebSettingsRoutes {
    static let edit = WebAdminRoutes.web.appendingPath(RouterPath("settings"))

    static var breadcrumb: [AdminBreadcrumb.Link] {
        WebAdminRoutes.breadcrumb + [
            .init(label: "Settings", link: edit.description)
        ]
    }
}
