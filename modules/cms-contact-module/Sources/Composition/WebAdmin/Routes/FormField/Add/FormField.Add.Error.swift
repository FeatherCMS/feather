import ContactApplication
import ContactModule

extension FormField.Add {
    enum Error: Swift.Error, Sendable {
        case unauthorized
        case forbidden
        case conflict
        case unavailable
        case createdButNotAssigned
    }
}
