import FeatherAdmin
import SystemModule

extension WebAdmin.System.Permission.List {
    enum Error: Swift.Error, Sendable {
        case unauthorized
        case forbidden
        case unavailable
    }
}
