public import FeatherModuleKit

extension RolePermission {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("auth:access-control:create")
        public static let read = PermissionKey("auth:access-control:read")
        public static let update = PermissionKey("auth:access-control:update")
        public static let list = PermissionKey("auth:access-control:list")
        public static let delete = PermissionKey("auth:access-control:delete")

        public static func all() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
}
