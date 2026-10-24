public import FeatherModuleKit

extension Category {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("news:category:create")
        public static let read = PermissionKey("news:category:read")
        public static let update = PermissionKey("news:category:update")
        public static let list = PermissionKey("news:category:list")
        public static let delete = PermissionKey("news:category:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
}
