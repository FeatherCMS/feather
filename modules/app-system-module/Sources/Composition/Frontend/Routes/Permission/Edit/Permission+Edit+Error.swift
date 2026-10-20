import FeatherAdmin
import SystemModule

extension WebAdmin.System.Permission.Edit {
    enum Error: Swift.Error, Sendable {
        case notFound
        case unauthorized
        case forbidden
        case conflict
        case unavailable
    }
}
