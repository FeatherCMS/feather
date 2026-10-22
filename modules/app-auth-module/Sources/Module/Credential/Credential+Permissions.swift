public import FeatherModuleKit

extension Credential {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("auth:credential:create")
        public static let read = PermissionKey("auth:credential:read")
        public static let update = PermissionKey("auth:credential:update")
        public static let delete = PermissionKey("auth:credential:delete")
        public static let find = PermissionKey("auth:credential:find")
        public static let list = PermissionKey("auth:credential:list")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, delete, find, list]
        }
    }
}
