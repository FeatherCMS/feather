import FeatherWebAdmin
import SystemModule

extension Permission.List {
    enum Error: Swift.Error, Sendable {
        case unauthorized
        case forbidden
        case unavailable
    }
}
