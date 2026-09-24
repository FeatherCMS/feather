enum AdminListUserRoleError: Error, Sendable {
    case unauthorized
    case forbidden
    case unavailable
}
