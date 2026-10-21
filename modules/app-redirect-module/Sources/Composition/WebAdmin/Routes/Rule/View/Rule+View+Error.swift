import RedirectModule
import RedirectApplication
extension RedirectModule.Rule.View {
    enum Error: Swift.Error, Sendable {
    case notFound
    case unauthorized
    case forbidden
    case unavailable
    }
}
