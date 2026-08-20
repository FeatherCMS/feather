import FeatherContracts

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
    public enum Fields: PermissionProvider {
        public static let create = PermissionKey("contact:form-fields:create")
        public static let read = PermissionKey("contact:form-fields:read")
        public static let update = PermissionKey("contact:form-fields:update")
        public static let list = PermissionKey("contact:form-fields:list")
        public static let delete = PermissionKey("contact:form-fields:delete")
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
    public enum Mails: PermissionProvider {
        public static let create = PermissionKey("contact:form-mails:create")
        public static let read = PermissionKey("contact:form-mails:read")
        public static let update = PermissionKey("contact:form-mails:update")
        public static let list = PermissionKey("contact:form-mails:list")
        public static let delete = PermissionKey("contact:form-mails:delete")
        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
    public static func allPermissions() -> Set<PermissionKey> {
        Forms.allPermissions().union(Fields.allPermissions())
            .union(Submissions.allPermissions())
            .union(Mails.allPermissions())
    }
}
