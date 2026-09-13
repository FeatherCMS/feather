import Foundation

enum AdminGetSystemJobError: Error, Sendable {
    case notFound
    case unauthorized
    case forbidden
    case unavailable
}
