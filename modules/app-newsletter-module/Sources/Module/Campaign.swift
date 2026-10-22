public import FeatherModuleKit

public enum Campaign {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("newsletter:campaigns:create")
        public static let read = PermissionKey("newsletter:campaigns:read")
        public static let update = PermissionKey("newsletter:campaigns:update")
        public static let list = PermissionKey("newsletter:campaigns:list")
        public static let delete = PermissionKey("newsletter:campaigns:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
}
