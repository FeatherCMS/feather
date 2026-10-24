import UserModule

extension Role.List {
    enum Error: Swift.Error, Sendable {
        case unauthorized
        case forbidden
        case unavailable
    }
}
