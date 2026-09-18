import FeatherAdmin
import FeatherContracts
import Foundation
import Hummingbird

enum SystemJobRoutes {
    static let list = SystemAdminRoutes.system.appendingPath(
        RouterPath("jobs")
    )

    static var listBreadcrumb: [NewAdminBreadcrumb.Link] {
        SystemAdminRoutes.breadcrumb
    }

    static var breadcrumb: [NewAdminBreadcrumb.Link] {
        SystemAdminRoutes.breadcrumb + [
            .init(label: "Worker jobs", link: list.description)
        ]
    }

    static func details(_ id: RouterPath) -> RouterPath {
        list.appendingPath(id)
    }

    static func listURL(
        page: Int? = nil,
        search: String? = nil,
        status: Int? = nil
    ) -> String {
        var query: [String] = []
        if let page, page > 1 {
            query.append("page=\(page)")
        }
        if let search = search?.emptyToNil {
            query.append(
                "search=\(search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? search)"
            )
        }
        if let status {
            query.append("status=\(status)")
        }
        let path = list.description + "/"
        return query.isEmpty ? path : "\(path)?\(query.joined(separator: "&"))"
    }
}
