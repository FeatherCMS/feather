public import FeatherModuleKit

extension Profile {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("account:profile:create")
        public static let read = PermissionKey("account:profile:read")
        public static let update = PermissionKey("account:profile:update")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update]
        }
    }
}
