public import FeatherModuleKit

extension Subscriber {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey(
            "newsletter:subscribers:create"
        )
        public static let read = PermissionKey("newsletter:subscribers:read")
        public static let update = PermissionKey(
            "newsletter:subscribers:update"
        )
        public static let list = PermissionKey("newsletter:subscribers:list")
        public static let delete = PermissionKey(
            "newsletter:subscribers:delete"
        )

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
}
