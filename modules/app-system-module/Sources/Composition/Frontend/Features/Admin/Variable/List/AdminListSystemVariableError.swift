enum AdminListSystemVariableError: Error, Sendable {
    case unauthorized
    case forbidden
    case unavailable
}
