import Foundation

enum AdminListUserIdentityError: Error, Sendable {
    case unauthorized
    case forbidden
    case unavailable
}
