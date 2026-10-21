import RedirectApplication
import RedirectModule
extension RedirectModule.Rule.Remove {
    enum Error: Swift.Error, Sendable {
    case notFound
    case unauthorized
    case forbidden
    case conflict
    case unavailable
    }
}
