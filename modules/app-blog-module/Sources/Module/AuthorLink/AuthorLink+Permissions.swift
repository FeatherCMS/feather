public import FeatherModuleKit

extension AuthorLink {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("blog:author-links:create")
        public static let read = PermissionKey("blog:author-links:read")
        public static let update = PermissionKey("blog:author-links:update")
        public static let list = PermissionKey("blog:author-links:list")
        public static let delete = PermissionKey("blog:author-links:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
}
