import Foundation

enum AdminGetUserRoleError: Error, Sendable {
    case notFound
    case unauthorized
    case forbidden
    case unavailable
}
