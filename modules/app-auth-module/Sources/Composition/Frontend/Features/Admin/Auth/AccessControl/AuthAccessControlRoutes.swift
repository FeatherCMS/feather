import FeatherAdmin
import Hummingbird

enum AuthAccessControlRoutes {
    static let accessControl = AuthAdminRoutes.auth.appendingPath(
        RouterPath("access-control")
    )

    static var breadcrumb: [NewAdminBreadcrumb.Link] {
        AuthAdminRoutes.breadcrumb + [
            .init(
                label: "Access Control",
                link: accessControl.description
            )
        ]
    }
}
