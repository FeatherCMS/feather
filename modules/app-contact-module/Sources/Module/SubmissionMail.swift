public import FeatherModuleKit

public enum SubmissionMail {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("contact:form-mails:create")
        public static let read = PermissionKey("contact:form-mails:read")
        public static let update = PermissionKey("contact:form-mails:update")
        public static let list = PermissionKey("contact:form-mails:list")
        public static let delete = PermissionKey("contact:form-mails:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
}
