import RedirectModule
import RedirectApplication
extension RedirectModule.Rule.List {
    enum Error: Swift.Error, Sendable {
    case unauthorized
    case forbidden
    case unavailable
    }
}
