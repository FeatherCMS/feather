public import FeatherModuleKit

extension Log {
    public enum Permissions: PermissionProvider {
        public static let list = PermissionKey("analytics:logs:list")

        public static func all() -> Set<PermissionKey> {
            [list]
        }
    }
}
