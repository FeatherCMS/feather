public import FeatherModuleKit

extension Settings {
    public enum Permissions: PermissionProvider {
        public static let read = PermissionKey("web:settings:read")
        public static let update = PermissionKey("web:settings:update")

        public static func all() -> Set<PermissionKey> {
            [read, update]
        }
    }
}
