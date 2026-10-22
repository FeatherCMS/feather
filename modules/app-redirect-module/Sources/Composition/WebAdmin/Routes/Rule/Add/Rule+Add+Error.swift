import RedirectApplication
import RedirectModule

extension Rule.Add {
    enum Error: Swift.Error, Sendable {
        case unauthorized
        case forbidden
        case conflict
        case unavailable
    }
}
