import FeatherAdmin
import SystemModule

extension WebAdmin.System.Variable.Add {
    enum Error: Swift.Error, Sendable {
        case unauthorized
        case forbidden
        case conflict
        case unavailable
    }
}
