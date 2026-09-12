import FeatherAdmin
import FeatherContracts
import Foundation
import Hummingbird

enum SystemJobRoutes {
    private static let admin = RouterPath("admin")
    private static let system = admin.appendingPath(RouterPath("system"))

    static let list = system.appendingPath(RouterPath("jobs"))

    static var breadcrumb: NewAdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "System", link: "/admin/system/"),
        ])
    }

    static func details(_ id: RouterPath) -> RouterPath {
        list.appendingPath(id)
    }

    static func listURL(page: Int? = nil, search: String? = nil) -> String {
        var query: [String] = []
        if let page, page > 1 {
            query.append("page=\(page)")
        }
        if let search = search?.emptyToNil {
            query.append("search=\(search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? search)")
        }
        let path = list.description + "/"
        return query.isEmpty ? path : "\(path)?\(query.joined(separator: "&"))"
    }
}
