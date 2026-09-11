import Hummingbird
import FeatherAdmin

enum SystemVariableRoutes {
    private static let admin = RouterPath("admin")
    private static let system = admin.appendingPath(RouterPath("system"))
    static let list = system.appendingPath(RouterPath("variables"))
    static let add = list.appendingPath(RouterPath("add"))
    static let removeRoute = list.appendingPath(RouterPath("remove"))

    static func details(_ id: RouterPath) -> RouterPath {
        list.appendingPath(id)
    }

    static func edit(_ id: RouterPath) -> RouterPath {
        details(id).appendingPath(RouterPath("edit"))
    }

    static func remove(_ id: String) -> String {
        "\(removeRoute.description)?ids=\(id.queryEncoded())"
    }
}
