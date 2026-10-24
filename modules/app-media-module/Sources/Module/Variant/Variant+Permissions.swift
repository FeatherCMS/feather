public import FeatherModuleKit

extension Variant {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("media:variants:create")
        public static let read = PermissionKey("media:variants:read")
        public static let list = PermissionKey("media:variants:list")
        public static let update = PermissionKey("media:variants:update")
        public static let delete = PermissionKey("media:variants:delete")

        public static func all() -> Set<PermissionKey> {
            [create, read, list, update, delete]
        }

        public static func allPermissions() -> Set<PermissionKey> {
            all()
        }
    }
}
