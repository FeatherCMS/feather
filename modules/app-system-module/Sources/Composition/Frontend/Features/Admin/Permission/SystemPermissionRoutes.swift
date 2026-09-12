import FeatherAdmin
import Hummingbird

enum SystemPermissionRoutes {
    private static let root = RouterPath("admin")
        .appendingPath(RouterPath("system"))
        .appendingPath(RouterPath("permissions"))
    static let list = root
    static let add = root.appendingPath(RouterPath("add"))
    static let remove = root.appendingPath(RouterPath("remove"))
    static var breadcrumb: NewAdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "System", link: "/admin/system/"),
            .init(label: "Permissions", link: list.description),
        ])
    }
    static func details(_ id: RouterPath) -> RouterPath {
        list.appendingPath(id)
    }
    static func edit(_ id: RouterPath) -> RouterPath {
        details(id).appendingPath(RouterPath("edit"))
    }
    static func removeFromList(_ id: String) -> String {
        "\(remove.description)?ids=\(id.queryEncoded())"
    }
    static func removeFromDetails(_ id: String) -> String {
        "\(remove.description)?ids=\(id.queryEncoded())&from=details"
    }
    static func removeFromEdit(_ id: String) -> String {
        "\(remove.description)?ids=\(id.queryEncoded())&from=edit"
    }
}
