public import FeatherModuleKit

extension Tag {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("blog:tags:create")
        public static let read = PermissionKey("blog:tags:read")
        public static let update = PermissionKey("blog:tags:update")
        public static let list = PermissionKey("blog:tags:list")
        public static let delete = PermissionKey("blog:tags:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
}
