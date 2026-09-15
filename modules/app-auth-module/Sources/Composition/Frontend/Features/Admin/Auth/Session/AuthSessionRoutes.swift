import FeatherAdmin
import Hummingbird

enum AuthSessionRoutes {
    static let identities = RouterPath("admin")
        .appendingPath(RouterPath("user"))
        .appendingPath(RouterPath("identities"))

    static func list(_ identityID: RouterPath) -> RouterPath {
        identities
            .appendingPath(identityID)
            .appendingPath(RouterPath("sessions"))
    }

    static func detailsBreadcrumb(
        _ identityID: RouterPath
    ) -> [NewAdminBreadcrumb.Link] {
        [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "User", link: "/admin/user/"),
            .init(label: "Identities", link: identities.description + "/"),
            .init(label: "Details", link: identities.appendingPath(identityID).description + "/"),
        ]
    }

    static func remove(
        _ identityID: RouterPath,
        sessionID: RouterPath
    ) -> RouterPath {
        list(identityID)
            .appendingPath(sessionID)
            .appendingPath(RouterPath("remove"))
    }
}
