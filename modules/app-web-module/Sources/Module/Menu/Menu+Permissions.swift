public import FeatherModuleKit

extension Menu {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("web:menus:create")
        public static let read = PermissionKey("web:menus:read")
        public static let update = PermissionKey("web:menus:update")
        public static let list = PermissionKey("web:menus:list")
        public static let delete = PermissionKey("web:menus:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
}
