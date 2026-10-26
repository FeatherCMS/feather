public import FeatherModuleKit

extension Author {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("blog:authors:create")
        public static let read = PermissionKey("blog:authors:read")
        public static let update = PermissionKey("blog:authors:update")
        public static let list = PermissionKey("blog:authors:list")
        public static let delete = PermissionKey("blog:authors:delete")

        public static func all() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
}
