import RedirectApplication
import RedirectModule

extension Rule.View {
    enum Error: Swift.Error, Sendable {
        case notFound
        case unauthorized
        case forbidden
        case unavailable
    }
}
