public import FeatherModuleKit

extension Insight {
    public enum Permissions: PermissionProvider {
        public static let list = PermissionKey("analytics:insights:list")

        public static func allPermissions() -> Set<PermissionKey> {
            [list]
        }
    }
}
