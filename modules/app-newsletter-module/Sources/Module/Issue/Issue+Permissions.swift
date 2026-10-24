public import FeatherModuleKit

extension Issue {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("newsletter:issues:create")
        public static let read = PermissionKey("newsletter:issues:read")
        public static let update = PermissionKey("newsletter:issues:update")
        public static let list = PermissionKey("newsletter:issues:list")
        public static let delete = PermissionKey("newsletter:issues:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
}
