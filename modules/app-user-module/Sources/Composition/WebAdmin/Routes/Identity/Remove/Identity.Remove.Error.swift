import UserModule

extension Identity.Remove {
    enum Error: Swift.Error, Sendable {
        case notFound
        case unauthorized
        case forbidden
        case conflict
        case unavailable
    }
}
