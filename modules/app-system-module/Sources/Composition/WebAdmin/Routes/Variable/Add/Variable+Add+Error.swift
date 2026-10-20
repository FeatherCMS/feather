import FeatherWebAdmin
import SystemModule

extension Variable.Add {
    enum Error: Swift.Error, Sendable {
        case unauthorized
        case forbidden
        case conflict
        case unavailable
    }
}
