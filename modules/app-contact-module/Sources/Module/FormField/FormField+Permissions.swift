public import FeatherModuleKit

extension FormField {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("contact:form-fields:create")
        public static let read = PermissionKey("contact:form-fields:read")
        public static let update = PermissionKey("contact:form-fields:update")
        public static let list = PermissionKey("contact:form-fields:list")
        public static let delete = PermissionKey("contact:form-fields:delete")

        public static func all() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
}
