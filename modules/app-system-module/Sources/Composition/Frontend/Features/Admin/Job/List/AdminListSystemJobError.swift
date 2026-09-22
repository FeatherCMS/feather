
enum AdminListSystemJobError: Error, Sendable {
    case unauthorized
    case forbidden
    case unavailable
}
