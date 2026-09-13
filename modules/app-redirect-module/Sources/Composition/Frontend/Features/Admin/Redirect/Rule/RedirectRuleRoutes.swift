import FeatherAdmin
import Hummingbird

enum RedirectRuleRoutes {
    private static let redirect = RouterPath("admin")
        .appendingPath(RouterPath("redirect"))
    static let list = redirect.appendingPath(RouterPath("rules"))
    static let add = list.appendingPath(RouterPath("add"))
    static let remove = list.appendingPath(RouterPath("remove"))

    static var breadcrumb: [NewAdminBreadcrumb.Link] {
        [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Redirect", link: redirect.description),
            .init(label: "Rules", link: list.description),
        ]
    }

    static var redirectBreadcrumb: [NewAdminBreadcrumb.Link] {
        breadcrumb.dropLast()
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
