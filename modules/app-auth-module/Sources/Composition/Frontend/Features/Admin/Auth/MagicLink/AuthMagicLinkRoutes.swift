import FeatherAdmin
import Hummingbird

enum AuthMagicLinkRoutes {
    static let list = AuthAdminRoutes.auth.appendingPath(
        RouterPath("magic-links")
    )
    static let add = list.appendingPath(RouterPath("add"))
    static let remove = list.appendingPath(RouterPath("remove"))

    static var listBreadcrumb: [NewAdminBreadcrumb.Link] {
        AuthAdminRoutes.breadcrumb
    }

    static var breadcrumb: [NewAdminBreadcrumb.Link] {
        AuthAdminRoutes.breadcrumb + [
            .init(label: "Magic links", link: list.description)
        ]
    }

    static func details(_ id: RouterPath) -> RouterPath {
        list.appendingPath(id)
    }

    static func edit(_ id: RouterPath) -> RouterPath {
        details(id).appendingPath(RouterPath("edit"))
    }

    static func remove(_ id: RouterPath) -> RouterPath {
        details(id).appendingPath(RouterPath("remove"))
    }
}
