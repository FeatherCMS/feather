public import FeatherModuleKit

extension AuthEmail {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("auth:email:create")
        public static let read = PermissionKey("auth:email:read")
        public static let update = PermissionKey("auth:email:update")
        public static let delete = PermissionKey("auth:email:delete")
        public static let list = PermissionKey("auth:email:list")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, delete, list]
        }
    }
}
