import Foundation

enum AdminViewUserRoleError: Error, Sendable {
    case notFound
    case unauthorized
    case forbidden
    case unavailable
}
