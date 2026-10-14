import FeatherAdmin
import Hummingbird

enum AuthCredentialRoutes {
    static let list = AuthAdminRoutes.auth.appendingPath(
        RouterPath("credentials")
    )
    static let add = list.appendingPath(RouterPath("add"))

    static var listBreadcrumb: [AdminBreadcrumb.Link] {
        AuthAdminRoutes.breadcrumb
    }

    static var breadcrumb: [AdminBreadcrumb.Link] {
        AuthAdminRoutes.breadcrumb + [
            .init(label: "Credentials", link: list.description)
        ]
    }

    static func detailsBreadcrumb(
        _ id: RouterPath
    ) -> [AdminBreadcrumb.Link] {
        breadcrumb + [
            .init(label: "User", link: details(id).description)
        ]
    }

    static func removeBreadcrumb(
        _ id: RouterPath
    ) -> [AdminBreadcrumb.Link] {
        detailsBreadcrumb(id) + [
            .init(label: "Remove", link: remove(id).description)
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
