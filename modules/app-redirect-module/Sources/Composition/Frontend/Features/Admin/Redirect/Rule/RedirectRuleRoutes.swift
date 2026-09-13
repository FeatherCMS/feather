import FeatherAdmin
import Hummingbird

enum RedirectRuleRoutes {
    static let list = RedirectAdminRoutes.redirect.appendingPath(
        RouterPath("rules")
    )
    static let add = list.appendingPath(RouterPath("add"))
    static let remove = list.appendingPath(RouterPath("remove"))
    static let detailsPattern = details(RouterPath("{id}"))
    static let editPattern = edit(RouterPath("{id}"))
    static let removePattern = remove(RouterPath("{id}"))

    static var breadcrumb: [NewAdminBreadcrumb.Link] {
        RedirectAdminRoutes.breadcrumb + [
            .init(label: "Rules", link: list.description),
        ]
    }

    static var redirectBreadcrumb: [NewAdminBreadcrumb.Link] {
        RedirectAdminRoutes.breadcrumb
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
