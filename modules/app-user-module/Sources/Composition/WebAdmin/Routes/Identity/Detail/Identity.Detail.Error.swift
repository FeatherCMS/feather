import UserModule

extension Identity.Detail {
    enum Error: Swift.Error, Sendable {
        case notFound
        case unauthorized
        case forbidden
        case unavailable
    }
}
