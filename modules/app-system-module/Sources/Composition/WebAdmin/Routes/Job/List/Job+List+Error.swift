import FeatherAdmin
import SystemModule

extension Job.List {
    enum Error: Swift.Error, Sendable {
        case unauthorized
        case forbidden
        case unavailable
    }
}
