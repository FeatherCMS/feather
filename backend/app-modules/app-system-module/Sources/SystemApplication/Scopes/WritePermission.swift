import SystemDomain
import Application

public struct WritePermission: Scope {
    public let permission: any PermissionRepository

    public init(permission: any PermissionRepository) {
        self.permission = permission
    }
}
