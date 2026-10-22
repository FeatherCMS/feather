import FeatherWebAdmin
import Hummingbird
import WebModule

enum SettingsRoutes {
    static let edit = AdminRoutes.web.appendingPath(RouterPath("settings"))

    static var breadcrumb: [AdminBreadcrumb.Link] {
        AdminRoutes.breadcrumb + [
            .init(label: "Settings", link: edit.description)
        ]
    }
}
