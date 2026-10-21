public import FeatherModuleKit

public enum Identity {
    public enum Add {}
    public enum Edit {}
    public enum Detail {
        public enum Query {}
    }
    public enum List {}
    public enum Search {}
    public enum Remove {}
    public enum Event {
        public enum Seed {}
    }

    public enum Permissions: PermissionProvider {
        public static let create = PermissionKey("user:identities:create")
        public static let read = PermissionKey("user:identities:read")
        public static let update = PermissionKey("user:identities:update")
        public static let list = PermissionKey("user:identities:list")
        public static let delete = PermissionKey("user:identities:delete")
        public static let me = PermissionKey("user:identities:me")

        public static func allPermissions() -> Set<PermissionKey> {
            [create, read, update, list, delete, me]
        }
    }
}
