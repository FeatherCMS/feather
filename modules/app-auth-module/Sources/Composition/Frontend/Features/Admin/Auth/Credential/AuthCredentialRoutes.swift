import FeatherAdmin
import Hummingbird

enum AuthCredentialRoutes {
    static let list = AuthAdminRoutes.auth.appendingPath(
        RouterPath("credentials")
    )
    static let add = list.appendingPath(RouterPath("add"))

    static var listBreadcrumb: [NewAdminBreadcrumb.Link] {
        AuthAdminRoutes.breadcrumb
    }

    static var breadcrumb: [NewAdminBreadcrumb.Link] {
        AuthAdminRoutes.breadcrumb + [
            .init(label: "Credentials", link: list.description)
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
