enum AdminListSystemPermissionError: Error, Sendable {
    case unauthorized
    case forbidden
    case unavailable
}
