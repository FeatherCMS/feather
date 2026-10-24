public import FeatherModuleKit

extension Article {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("news:article:create")
        public static let read = PermissionKey("news:article:read")
        public static let update = PermissionKey("news:article:update")
        public static let list = PermissionKey("news:article:list")
        public static let delete = PermissionKey("news:article:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
}
