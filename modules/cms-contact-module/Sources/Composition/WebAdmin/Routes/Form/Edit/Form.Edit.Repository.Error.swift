import ContactApplication
import ContactModule

extension ContactModule.Form.Edit.Repository {
    enum Error: Swift.Error, Sendable {
        case notFound
        case unauthorized
        case forbidden
        case conflict
        case unavailable
    }
}
