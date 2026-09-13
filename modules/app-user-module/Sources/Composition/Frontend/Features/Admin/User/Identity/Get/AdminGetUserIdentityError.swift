import Foundation

enum AdminGetUserIdentityError: Error, Sendable {
    case notFound
    case unauthorized
    case forbidden
    case unavailable
}
