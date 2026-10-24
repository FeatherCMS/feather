public import FeatherModuleKit

extension Asset {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("media:assets:create")
        public static let read = PermissionKey("media:assets:read")
        public static let update = PermissionKey("media:assets:update")
        public static let list = PermissionKey("media:assets:list")
        public static let delete = PermissionKey("media:assets:delete")

        public static func all() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }

        public static func allPermissions() -> Set<PermissionKey> {
            all()
        }
    }
}
