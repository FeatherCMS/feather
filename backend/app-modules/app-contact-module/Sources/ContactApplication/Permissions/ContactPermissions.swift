import Application

public enum ContactPermissions: PermissionProvider {
    public enum Forms: PermissionProvider {
        public static let create = PermissionKey("contact:forms:create")
        public static let read = PermissionKey("contact:forms:read")
        public static let update = PermissionKey("contact:forms:update")
        public static let list = PermissionKey("contact:forms:list")
        public static let delete = PermissionKey("contact:forms:delete")
        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
    public enum Items: PermissionProvider {
        public static let create = PermissionKey("contact:form-items:create")
        public static let read = PermissionKey("contact:form-items:read")
        public static let update = PermissionKey("contact:form-items:update")
        public static let list = PermissionKey("contact:form-items:list")
        public static let delete = PermissionKey("contact:form-items:delete")
        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
    public enum Submissions: PermissionProvider {
        public static let read = PermissionKey("contact:form-submissions:read")
        public static let update = PermissionKey(
            "contact:form-submissions:update"
        )
        public static let list = PermissionKey("contact:form-submissions:list")
        public static let delete = PermissionKey(
            "contact:form-submissions:delete"
        )
        public static func allPermissions() -> Set<PermissionKey> {
            [read, update, list, delete]
        }
    }
    public static func allPermissions() -> Set<PermissionKey> {
        Forms.allPermissions().union(Items.allPermissions())
            .union(Submissions.allPermissions())
    }
}
