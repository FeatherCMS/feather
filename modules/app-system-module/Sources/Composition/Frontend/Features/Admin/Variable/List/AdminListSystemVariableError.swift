import Foundation

enum AdminListSystemVariableError: Error, Sendable {
    case unauthorized
    case forbidden
    case unavailable
}
