import Foundation

enum AdminGetSystemVariableError: Error, Sendable {
    case notFound
    case unauthorized
    case forbidden
    case unavailable
}
