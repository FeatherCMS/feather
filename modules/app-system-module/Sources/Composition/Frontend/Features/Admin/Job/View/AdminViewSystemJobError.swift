enum AdminViewSystemJobError: Error, Sendable {
    case notFound
    case unauthorized
    case forbidden
    case unavailable
}
