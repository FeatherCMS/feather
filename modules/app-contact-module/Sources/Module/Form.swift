public import FeatherModuleKit

public enum Form {
    public enum Add {}
    public enum Edit {}
    public enum Detail {}
    public enum Public {
        public enum Detail {}
    }
    public enum List {}
    public enum Remove {}
    public enum Submit {}

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
