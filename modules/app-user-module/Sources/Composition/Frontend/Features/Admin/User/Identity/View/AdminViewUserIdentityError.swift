import Foundation

enum AdminViewUserIdentityError: Error, Sendable {
    case notFound
    case unauthorized
    case forbidden
    case unavailable
}
