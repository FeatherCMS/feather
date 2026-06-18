import Application

public enum BlogPermissions: PermissionProvider {

    public enum Posts: PermissionProvider {
        public static let create = PermissionKey("blog:posts:create")
        public static let read = PermissionKey("blog:posts:read")
        public static let update = PermissionKey("blog:posts:update")
        public static let list = PermissionKey("blog:posts:list")
        public static let delete = PermissionKey("blog:posts:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }

    public enum Tags: PermissionProvider {
        public static let create = PermissionKey("blog:tags:create")
        public static let read = PermissionKey("blog:tags:read")
        public static let update = PermissionKey("blog:tags:update")
        public static let list = PermissionKey("blog:tags:list")
        public static let delete = PermissionKey("blog:tags:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }

    public enum Authors: PermissionProvider {
        public static let create = PermissionKey("blog:authors:create")
        public static let read = PermissionKey("blog:authors:read")
        public static let update = PermissionKey("blog:authors:update")
        public static let list = PermissionKey("blog:authors:list")
        public static let delete = PermissionKey("blog:authors:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }

    public enum AuthorLinks: PermissionProvider {
        public static let create = PermissionKey("blog:author-links:create")
        public static let read = PermissionKey("blog:author-links:read")
        public static let update = PermissionKey("blog:author-links:update")
        public static let list = PermissionKey("blog:author-links:list")
        public static let delete = PermissionKey("blog:author-links:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }

    public enum Settings: PermissionProvider {
        public static let read = PermissionKey("blog:settings:read")
        public static let update = PermissionKey("blog:settings:update")

        public static func allPermissions() -> Set<PermissionKey> {
            [read, update]
        }
    }

    public static func allPermissions() -> Set<PermissionKey> {
        Posts.allPermissions()
            .union(Tags.allPermissions())
            .union(Authors.allPermissions())
            .union(AuthorLinks.allPermissions())
            .union(Settings.allPermissions())
    }
}
