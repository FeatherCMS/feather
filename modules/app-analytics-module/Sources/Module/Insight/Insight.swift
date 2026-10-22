public import FeatherModuleKit

public enum Insight {
    public enum Permissions: PermissionProvider {
        public static let list = PermissionKey("analytics:insights:list")

        public static func allPermissions() -> Set<PermissionKey> {
            [list]
        }
    }
}
