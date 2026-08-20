import FeatherContracts

public enum AccountPermissions: PermissionProvider {

    public enum Invitations: PermissionProvider {
        public static let create = PermissionKey("account:invitations:create")
        public static let read = PermissionKey("account:invitations:read")
        public static let list = PermissionKey("account:invitations:list")
        public static let update = PermissionKey("account:invitations:update")
        public static let delete = PermissionKey("account:invitations:delete")

        public static func allPermissions() -> Set<PermissionKey> {
            [
                create,
                read,
                list,
                update,
                delete,
            ]
        }
    }

    public static func allPermissions() -> Set<PermissionKey> {
        Invitations.allPermissions()
    }
}
