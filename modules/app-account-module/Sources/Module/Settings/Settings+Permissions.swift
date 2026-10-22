public import FeatherModuleKit

extension Settings {
    public enum Permissions: PermissionProvider {
        public static let read = PermissionKey("account:settings:read")
        public static let update = PermissionKey("account:settings:update")

        public static func allPermissions() -> Set<PermissionKey> {
            [read, update]
        }
    }
}
