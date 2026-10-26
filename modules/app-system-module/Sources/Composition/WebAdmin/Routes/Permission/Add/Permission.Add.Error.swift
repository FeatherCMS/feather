import FeatherWebAdmin
import SystemModule

extension Permission.Add {
    enum Error: Swift.Error, Sendable {
        case unauthorized
        case forbidden
        case conflict
        case unavailable
    }
}
