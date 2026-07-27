import Application

public enum NewsletterPermissions: PermissionProvider {
    public enum Campaigns: PermissionProvider {
        public static let create = PermissionKey("newsletter:campaigns:create")
        public static let read = PermissionKey("newsletter:campaigns:read")
        public static let update = PermissionKey("newsletter:campaigns:update")
        public static let list = PermissionKey("newsletter:campaigns:list")
        public static let delete = PermissionKey("newsletter:campaigns:delete")
        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
    public enum Subscribers: PermissionProvider {
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
    public enum Issues: PermissionProvider {
        public static let create = PermissionKey("newsletter:issues:create")
        public static let read = PermissionKey("newsletter:issues:read")
        public static let update = PermissionKey("newsletter:issues:update")
        public static let list = PermissionKey("newsletter:issues:list")
        public static let delete = PermissionKey("newsletter:issues:delete")
        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
    public static func allPermissions() -> Set<PermissionKey> {
        Campaigns.allPermissions().union(Subscribers.allPermissions())
            .union(Issues.allPermissions())
    }
}
