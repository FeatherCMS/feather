public import FeatherModuleKit

extension Settings {
    public enum Permissions: PermissionProvider {
        public static let read = PermissionKey("blog:settings:read")
        public static let update = PermissionKey("blog:settings:update")

        public static func allPermissions() -> Set<PermissionKey> {
            [read, update]
        }
    }
}
