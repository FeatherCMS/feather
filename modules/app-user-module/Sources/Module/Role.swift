public import FeatherModuleKit

public enum Role {
    public enum Add {}
    public enum Edit {}
    public enum Detail {}
    public enum List {}
    public enum Search {}
    public enum Remove {}
    public enum Query {}
    public enum Event {
        public enum Seed {}
    }

    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("user:roles:create")
        public static let read = PermissionKey("user:roles:read")
        public static let update = PermissionKey("user:roles:update")
        public static let list = PermissionKey("user:roles:list")
        public static let delete = PermissionKey("user:roles:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete]
        }
    }
}
