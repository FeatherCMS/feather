public import FeatherModuleKit

extension Page {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("web:pages:create")
        public static let read = PermissionKey("web:pages:read")
        public static let update = PermissionKey("web:pages:update")
        public static let list = PermissionKey("web:pages:list")
        public static let delete = PermissionKey("web:pages:delete")

        public static func all() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
}
