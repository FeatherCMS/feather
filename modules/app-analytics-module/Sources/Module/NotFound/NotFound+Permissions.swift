public import FeatherModuleKit

extension NotFound {
    public enum Permissions: PermissionProvider {
        public static let list = PermissionKey("analytics:not-found:list")

        public static func all() -> Set<PermissionKey> {
            [list]
        }
    }
}
