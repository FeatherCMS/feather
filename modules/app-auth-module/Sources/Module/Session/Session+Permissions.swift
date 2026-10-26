public import FeatherModuleKit

extension Session {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("auth:sessions:create")
        public static let read = PermissionKey("auth:sessions:read")
        public static let update = PermissionKey("auth:sessions:update")
        public static let list = PermissionKey("auth:sessions:list")
        public static let delete = PermissionKey("auth:sessions:delete")

        public static func all() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
}
