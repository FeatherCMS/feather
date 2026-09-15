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

    static func remove(
        _ identityID: RouterPath,
        sessionID: RouterPath
    ) -> RouterPath {
        list(identityID)
            .appendingPath(sessionID)
            .appendingPath(RouterPath("remove"))
    }
}
