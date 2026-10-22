import RedirectApplication
import RedirectModule

extension Rule.List {
    enum Error: Swift.Error, Sendable {
        case unauthorized
        case forbidden
        case unavailable
    }
}
