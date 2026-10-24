import FeatherWebAdmin
import SystemModule

extension Variable.List {
    enum Error: Swift.Error, Sendable {
        case unauthorized
        case forbidden
        case unavailable
    }
}
