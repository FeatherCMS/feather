import Foundation

enum AdminViewSystemVariableError: Error, Sendable {
    case notFound
    case unauthorized
    case forbidden
    case unavailable
}
