import AuthDomain
import Application

public struct WriteRolePermissions: Scope {

    public let rolePermissions: any RolePermissionRepository

    public init(
        rolePermissions: any RolePermissionRepository
    ) {
        self.rolePermissions = rolePermissions
    }
}
