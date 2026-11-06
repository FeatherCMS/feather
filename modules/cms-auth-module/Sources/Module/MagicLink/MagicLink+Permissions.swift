public import FeatherModuleKit

extension MagicLink {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("auth:magic-links:create")
        public static let read = PermissionKey("auth:magic-links:read")
        public static let update = PermissionKey("auth:magic-links:update")
        public static let list = PermissionKey("auth:magic-links:list")
        public static let delete = PermissionKey("auth:magic-links:delete")

        public static func all() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
}
