
enum AdminAddUserRoleError: Error, Sendable {
    case unauthorized
    case forbidden
    case conflict
    case unavailable
}
