public import FeatherModuleKit

extension Post {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("blog:posts:create")
        public static let read = PermissionKey("blog:posts:read")
        public static let update = PermissionKey("blog:posts:update")
        public static let list = PermissionKey("blog:posts:list")
        public static let delete = PermissionKey("blog:posts:delete")

        public static func all() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
}
