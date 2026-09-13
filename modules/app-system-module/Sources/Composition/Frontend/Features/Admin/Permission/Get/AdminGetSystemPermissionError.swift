import Foundation

enum AdminGetSystemPermissionError: Error, Sendable {
    case notFound
    case unauthorized
    case forbidden
    case unavailable
}
