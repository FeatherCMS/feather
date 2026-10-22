import FeatherWebAdmin
import Hummingbird

enum PageRoutes {
    static let list = AdminRoutes.web.appendingPath(RouterPath("pages"))
    static let add = list.appendingPath(RouterPath("add"))
    static let remove = list.appendingPath(RouterPath("remove"))

    static var breadcrumb: [AdminBreadcrumb.Link] {
        AdminRoutes.breadcrumb + [
            .init(label: "Pages", link: list.description)
        ]
    }

    static var listBreadcrumb: [AdminBreadcrumb.Link] {
        AdminRoutes.breadcrumb
    }

    static func details(_ id: RouterPath) -> RouterPath {
        list.appendingPath(id)
    }

    static func edit(_ id: RouterPath) -> RouterPath {
        details(id).appendingPath(RouterPath("edit"))
    }

    static func metadata(
        _ id: RouterPath,
        _ metadataID: RouterPath
    ) -> RouterPath {
        edit(id)
            .appendingPath(RouterPath("metadata"))
            .appendingPath(metadataID)
    }

    static func status(_ id: RouterPath) -> RouterPath {
        details(id).appendingPath(RouterPath("status"))
    }
}
