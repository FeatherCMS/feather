public import FeatherModuleKit


extension Form {
    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("contact:forms:create")
        public static let read = PermissionKey("contact:forms:read")
        public static let update = PermissionKey("contact:forms:update")
        public static let list = PermissionKey("contact:forms:list")
        public static let delete = PermissionKey("contact:forms:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
}
