import FeatherWebAdmin
import SystemModule

extension Variable.Remove {
    enum Error: Swift.Error, Sendable {
        case notFound
        case unauthorized
        case forbidden
        case conflict
        case unavailable
    }
}
