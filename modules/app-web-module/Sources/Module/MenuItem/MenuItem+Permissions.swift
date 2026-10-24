public import FeatherModuleKit

extension MenuItem {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("web:menu-items:create")
        public static let read = PermissionKey("web:menu-items:read")
        public static let update = PermissionKey("web:menu-items:update")
        public static let list = PermissionKey("web:menu-items:list")
        public static let delete = PermissionKey("web:menu-items:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
}
