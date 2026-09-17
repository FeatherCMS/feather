import FeatherAdmin
import Foundation
import Hummingbird

enum WebMetadataRoutes {
    static let list = WebAdminRoutes.web.appendingPath(RouterPath("metadata"))

    static var breadcrumb: [NewAdminBreadcrumb.Link] {
        WebAdminRoutes.breadcrumb + [
            .init(label: "Metadata", link: list.description)
        ]
    }

    static func editBreadcrumb(
        for requestPath: String
    ) -> [NewAdminBreadcrumb.Link] {
        if let marker = requestPath.range(of: "/edit/metadata/") {
            let detailsPath =
                String(requestPath[..<marker.lowerBound]) + "/edit/"
            return [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Details", link: detailsPath),
            ]
        }
        return breadcrumb
    }

    static func details(_ id: RouterPath) -> RouterPath {
        list.appendingPath(id)
    }

    static func edit(_ id: RouterPath) -> RouterPath {
        details(id).appendingPath(RouterPath("edit"))
    }
}
