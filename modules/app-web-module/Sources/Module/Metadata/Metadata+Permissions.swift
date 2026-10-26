public import FeatherModuleKit

extension Metadata {
    public enum Permissions: PermissionProvider {
        public static let access = PermissionKey("web:metadata:access")

        public static func all() -> Set<PermissionKey> {
            [access]
        }
    }
}
