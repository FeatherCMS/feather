import FeatherAdmin
import SystemModule

extension Permission.Edit {
    enum Error: Swift.Error, Sendable {
        case notFound
        case unauthorized
        case forbidden
        case conflict
        case unavailable
    }
}
