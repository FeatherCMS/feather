public import FeatherModuleKit

public enum Submission {
    public enum Detail {}
    public enum Edit {}
    public enum List {}
    public enum Remove {}

    public enum Permissions: PermissionProvider {
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
}
