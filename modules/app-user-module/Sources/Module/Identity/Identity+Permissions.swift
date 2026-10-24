public import FeatherModuleKit

extension Identity {
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
