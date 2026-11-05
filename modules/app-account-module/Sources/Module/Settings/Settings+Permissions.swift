public import FeatherModuleKit

extension Settings {
    public enum Permissions: PermissionProvider {
        public static let read = PermissionKey("account:settings:read")
        public static let update = PermissionKey("account:settings:update")

        public static func all() -> Set<PermissionKey> {
            [read, update]
        }
    }
}
