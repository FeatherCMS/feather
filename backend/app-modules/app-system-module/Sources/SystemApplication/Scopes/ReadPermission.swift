import SystemDomain
import Application

public struct ReadPermission: Scope {
    public let permission: any PermissionQueries

    public init(permission: any PermissionQueries) {
        self.permission = permission
    }
}
