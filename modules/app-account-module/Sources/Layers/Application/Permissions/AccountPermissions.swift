import FeatherApplication
import FeatherContracts

public enum AccountPermissions: PermissionProvider {

    public enum Invitations: PermissionProvider {
        static let create = PermissionKey("account:invitations:create")
        static let read = PermissionKey("account:invitations:read")
        static let list = PermissionKey("account:invitations:list")
        static let update = PermissionKey("account:invitations:update")
        static let delete = PermissionKey("account:invitations:delete")

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
