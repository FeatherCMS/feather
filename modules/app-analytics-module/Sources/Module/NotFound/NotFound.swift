public import FeatherModuleKit

public enum NotFound {
    public enum Permissions: PermissionProvider {
        public static let list = PermissionKey("analytics:not-found:list")

        public static func allPermissions() -> Set<PermissionKey> {
            [list]
        }
    }
}
