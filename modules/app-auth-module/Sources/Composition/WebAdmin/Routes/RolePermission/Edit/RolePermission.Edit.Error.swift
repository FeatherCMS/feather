import AuthModule

extension RolePermission.Edit {
    enum Error: Swift.Error, Sendable {
        case unauthorized
        case forbidden
        case conflict
        case unavailable
    }
}
