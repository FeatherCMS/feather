import UserModule

extension Identity.Add {
    enum Error: Swift.Error, Sendable {
        case unauthorized
        case forbidden
        case conflict
        case unavailable
    }
}
