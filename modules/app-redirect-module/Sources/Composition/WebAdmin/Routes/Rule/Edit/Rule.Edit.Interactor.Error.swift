import RedirectApplication
import RedirectModule

extension Rule.Edit.Interactor {
    enum Error: Swift.Error, Sendable {
        case notFound
        case unauthorized
        case forbidden
        case conflict
        case unavailable
    }
}
