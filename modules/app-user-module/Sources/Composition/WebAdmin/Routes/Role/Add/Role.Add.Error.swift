import UserModule

extension Role.Add {
    enum Error: Swift.Error, Sendable {
        case unauthorized
        case forbidden
        case conflict
        case unavailable
    }
}
